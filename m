From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH kvmtool v2 0/6] arm: Add support for firmware booting
Date: Tue, 22 Jan 2019 09:00:01 +0000
Message-ID: <b5e4bd1c-8bb5-36ca-026e-59fd92a4486d@arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
 <20190122071024.GB10214@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BB14A387
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 04:00:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jq6up00xI8WT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 04:00:06 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 657C64A379
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 04:00:06 -0500 (EST)
In-Reply-To: <20190122071024.GB10214@brain-police>
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
To: Will Deacon <will.deacon@arm.com>
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 22/01/2019 07:10, Will Deacon wrote:
> Hi Julien,
> 
> On Thu, Jan 10, 2019 at 02:20:40PM +0000, Julien Thierry wrote:
>> This series is based on the virtio reset series[1] posted earlier.
>>
>> We would like to be able to load firmwares like UEFI in kvmtool.
>>
>> The series contains:
>> A way to load the firmware into RAM and an option to be able to create
>> non-volatile memory zones and load data into them.
>>
>> Those non-volatile memory are presented throught the DT with a node:
>>
>> 	<flash>@<addr> {
>> 		compatible = "kvmtool,flash";
>> 		reg = < <addr> <size> >;
>> 		label = <name>;
>> 	}
>>
>> These are expected to be dealt with by specific kvmtool driver and not
>> to be picked up by existing drivers (although technically it is just
>> plain memory, mapped in the guest).
> 
> I've picked up the first four patches of this series, but I don't really

Thanks!

> understand where you're going with the non-volatile memory part and whether
> it's nvram, flash or something completely different. Given that Linux
> doesn't support your binding, is this something that UEFI currently uses?
> 

So the thing is that UEFI/EDK2 needs some kind of readable and writable
non-volatile memory (flash or nv-ram, not sure what's the difference) to
load/store its environment. For kvmtool, we can just provide memory
region where the environment is mapped and EDK2 can just directly read
from or write to it.

The thing is, when looking at the flash binding in Linux, each platform
seems to have its own binding of their flash device (Which I guess makes
sense since they don't necessarily work the same way). I couldn't find
any existing generic bindings that seemed to fit what I'm presenting to
EDK2 (which could also be used by another firmware if they needed a
binary blob in flash or something).

Another thing I wanted to avoid would be an existing Linux driver
picking up on the "flash device" kvmtool is presenting (don't want it
directly messing up with EFI environment). The idea is that you would
use this memory only if you explicitly added the support in the software
for this platform.

EDK2 doesn't already use it (not upstream), but it is part of the
support to boot EDK2 under kvmtool series (on the EDK2 side). So, this
is not set in stone yet and if you suggestion I can still check with
Sami if that works on his side and implement it.

Thanks,

-- 
Julien Thierry
