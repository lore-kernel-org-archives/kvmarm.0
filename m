From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 5/7] lib: arm: Fallback to
 psci_system_off() in exit()
Date: Fri, 25 Jan 2019 14:18:24 +0000
Message-ID: <8ee7bb48-1d9b-327f-dd49-7ed62759a0be@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-6-alexandru.elisei@arm.com>
 <20190124130020.5gjoblt5lqqujzqw@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6104A3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 09:18:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HaCjAe2fJ7AO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 09:18:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73CC4A376
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 09:18:27 -0500 (EST)
In-Reply-To: <20190124130020.5gjoblt5lqqujzqw@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


On 1/24/19 1:00 PM, Andrew Jones wrote:
> On Thu, Jan 24, 2019 at 11:16:32AM +0000, Alexandru Elisei wrote:
>> On arm and arm64, kvm-unit-tests uses the QEMU chr-testdev device to shut
>> down the virtual machine at the end of a test. The function
>> psci_system_off() provides another mechanism for terminating the virtual
>> machine. If the chr-testdev device hasn't been initialized successfully,
>> then use psci_system_off() to terminate the test instead of
>> chr_testdev_exit().
>>
>> chr-testdev is implemented on top of virtio console. This patch makes it
>> possible for a virtual machine manager which doesn't have support for
>> chr-testdev, but has been configured not to emulate a virtio console, to
>> gracefully terminate a virtual machine after a test has been completed.
>>
>> There is one limitation to using psci_system_off() to terminate a test:
>> chr-testdev allows kvm-unit-tests to specify an exit code;
>> psci_system_off() has no such mechanism.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/io.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>> index 87435150f73e..9fe9bd0bf659 100644
>> --- a/lib/arm/io.c
>> +++ b/lib/arm/io.c
>> @@ -11,6 +11,7 @@
>>  #include <libcflat.h>
>>  #include <devicetree.h>
>>  #include <chr-testdev.h>
>> +#include "arm/asm/psci.h"
>>  #include <asm/spinlock.h>
>>  #include <asm/io.h>
>>  
>> @@ -18,6 +19,8 @@
>>  
>>  extern void halt(int code);
>>  
>> +static bool testdev_enabled;
>> +
>>  /*
>>   * Use this guess for the pl011 base in order to make an attempt at
>>   * having earlier printf support. We'll overwrite it with the real
>> @@ -65,8 +68,12 @@ static void uart0_init(void)
>>  
>>  void io_init(void)
>>  {
>> +	int err;
>> +
>>  	uart0_init();
>> -	chr_testdev_init();
>> +	err = chr_testdev_init();
>> +	if (!err)
>> +		testdev_enabled = true;
>>  }
>>  
>>  void puts(const char *s)
>> @@ -79,7 +86,10 @@ void puts(const char *s)
>>  
>>  void exit(int code)
>>  {
>> -	chr_testdev_exit(code);
>> +	if (testdev_enabled)
>> +		chr_testdev_exit(code);
>> +	else
>> +		psci_system_off();
>>  	halt(code);
>>  	__builtin_unreachable();
>>  }
>> -- 
>> 2.17.0
>>
> chr_testdev_init() ensures vcon is NULL if it fails to initialize.
> chr_testdev_exit() immediately returns if vcon is NULL. This was
> done by design to allow fallback exits to be placed below the
> chr_testdev_exit call, e.g. halt().
>
> We should be able to drop patch 3/7 and change exit() to this
>
>   void exit(int code)
>   {
>       chr_testdev_exit(code);
>       psci_system_off();
>       halt(code);
>       __builtin_unreachable();
>   }
>
> Thanks,
> drew
I wasn't aware of this design decision, thank you for explaining it. I'll
implement the changes you suggested, including dropping patch 3/7: "lib:
chr-testdev: Make chr_testdev_init() return status".
