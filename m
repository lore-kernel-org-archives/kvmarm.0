Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7560EC43461
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 14:43:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2D6F6142A
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 14:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2D6F6142A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287884B243;
	Wed, 28 Apr 2021 10:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1v4cf4meuafU; Wed, 28 Apr 2021 10:43:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0944B266;
	Wed, 28 Apr 2021 10:43:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 431CD4B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 10:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vo4nDmC3CiYT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 10:43:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA9C4B243
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 10:43:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7247EED1;
 Wed, 28 Apr 2021 07:43:44 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF0D03F694;
 Wed, 28 Apr 2021 07:43:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm: Replace --vmm with
 --target
To: Andrew Jones <drjones@redhat.com>
References: <20210427163437.243839-1-alexandru.elisei@arm.com>
 <20210427171011.ymu7j5sen76c4xb3@gator.home>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c10442e1-f7e1-e777-c33e-d103276febf8@arm.com>
Date: Wed, 28 Apr 2021 15:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427171011.ymu7j5sen76c4xb3@gator.home>
Content-Language: en-US
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Drew,

On 4/27/21 6:10 PM, Andrew Jones wrote:
> On Tue, Apr 27, 2021 at 05:34:37PM +0100, Alexandru Elisei wrote:
>> The --vmm configure option was added to distinguish between the two virtual
>> machine managers that kvm-unit-tests supports, qemu or kvmtool. There are
>> plans to make kvm-unit-tests work as an EFI app, which will require changes
>> to the way tests are compiled. Instead of adding a new configure option
>> specifically for EFI and have it coexist with --vmm, or overloading the
>> semantics of the existing --vmm option, let's replace --vmm with the more
>> generic name --target.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> Changes in v2:
>>
>> * Removed the RFC tag and cover letter.
>> * Removed --vmm entirely.
>>
>>  configure | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 01a0b262a9f2..08c6afdf952c 100755
>> --- a/configure
>> +++ b/configure
>> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>>  environ_default=yes
>>  u32_long=
>>  wa_divide=
>> -vmm="qemu"
>> +target="qemu"
>>  errata_force=0
>>  erratatxt="$srcdir/errata.txt"
>>  host_key_document=
>> @@ -35,8 +35,8 @@ usage() {
>>  	Options include:
>>  	    --arch=ARCH            architecture to compile for ($arch)
>>  	    --processor=PROCESSOR  processor to compile for ($arch)
>> -	    --vmm=VMM              virtual machine monitor to compile for (qemu
>> -	                           or kvmtool, default is qemu) (arm/arm64 only)
>> +	    --target=TARGET        target platform that the tests will be running on (qemu or
>> +	                           kvmtool, default is qemu) (arm/arm64 only)
>>  	    --cross-prefix=PREFIX  cross compiler prefix
>>  	    --cc=CC		   c compiler to use ($cc)
>>  	    --ld=LD		   ld linker to use ($ld)
>> @@ -58,7 +58,7 @@ usage() {
>>  	    --earlycon=EARLYCON
>>  	                           Specify the UART name, type and address (optional, arm and
>>  	                           arm64 only). The specified address will overwrite the UART
>> -	                           address set by the --vmm option. EARLYCON can be one of
>> +	                           address set by the --target option. EARLYCON can be one of
>>  	                           (case sensitive):
>>  	               uart[8250],mmio,ADDR
>>  	                           Specify an 8250 compatible UART at address ADDR. Supported
>> @@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
>>          --processor)
>>  	    processor="$arg"
>>  	    ;;
>> -	--vmm)
>> -	    vmm="$arg"
>> +	--target)
>> +	    target="$arg"
>>  	    ;;
>>  	--cross-prefix)
>>  	    cross_prefix="$arg"
>> @@ -177,13 +177,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>>      testdir=x86
>>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>>      testdir=arm
>> -    if [ "$vmm" = "qemu" ]; then
>> +    if [ "$target" = "qemu" ]; then
>>          arm_uart_early_addr=0x09000000
>> -    elif [ "$vmm" = "kvmtool" ]; then
>> +    elif [ "$target" = "kvmtool" ]; then
>>          arm_uart_early_addr=0x3f8
>>          errata_force=1
>>      else
>> -        echo '--vmm must be one of "qemu" or "kvmtool"!'
>> +        echo '--target must be one of "qemu" or "kvmtool"!'
>>          usage
>>      fi
>>  
>> @@ -317,6 +317,7 @@ U32_LONG_FMT=$u32_long
>>  WA_DIVIDE=$wa_divide
>>  GENPROTIMG=${GENPROTIMG-genprotimg}
>>  HOST_KEY_DOCUMENT=$host_key_document
>> +TARGET=$target
> We should only emit this TARGET=qemu to the config.mak when we're
> arm/arm64, since that's what the help text says. Also, because the help
> text says that the --target option is only for arm/arm64, then configure
> should error out if it's used with another architecture. The nice thing
> about this rename is that we can get that right this time. We didn't error
> out with --vmm, but we should have. Erroring out on an unsupported
> feature allows us to add support for it later without the users having
> to guess if it'll work or not.

You're right, I'll fix it for v3.

Thanks,

Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
