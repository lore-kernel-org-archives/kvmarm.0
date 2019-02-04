From: Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Add --vmm
 option with no effect
Date: Mon, 4 Feb 2019 09:56:13 +0000
Message-ID: <62f7f56e-804b-1236-bc18-72b61d65e28f@arm.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
 <20190201111641.8299-3-alexandru.elisei@arm.com>
 <20190202155100.gk4rnpgpdlbjpoh2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 571FE4A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 04:56:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WejaAlQYJZBe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 04:56:16 -0500 (EST)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150087.outbound.protection.outlook.com [40.107.15.87])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F71C4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 04:56:16 -0500 (EST)
In-Reply-To: <20190202155100.gk4rnpgpdlbjpoh2@kamzik.brq.redhat.com>
Content-Language: en-US
Content-ID: <90FBAAA036ECA94EABB6BF8E99850DA1@eurprd08.prod.outlook.com>
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
Cc: Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2/2/19 3:51 PM, Andrew Jones wrote:
> On Fri, Feb 01, 2019 at 11:16:38AM +0000, Alexandru Elisei wrote:
>> Add configuration option --vmm to specify the virtual machine manager.
>> Valid choices are 'qemu' and 'kvmtool', the default being 'qemu'. This
>> option is only available for the arm and arm64 architectures and does
>> nothing for now.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  configure | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/configure b/configure
>> index 44708b026422..0786e1604dba 100755
>> --- a/configure
>> +++ b/configure
>> @@ -16,6 +16,7 @@ endian=""
>>  pretty_print_stacks=yes
>>  environ_default=yes
>>  u32_long=
>> +vmm="qemu"
>>
>>  usage() {
>>      cat <<-EOF
>> @@ -24,6 +25,8 @@ usage() {
>>  Options include:
>>      --arch=ARCH            architecture to compile for ($arch)
>>      --processor=PROCESSOR  processor to compile for ($arch)
>> +    --vmm=VMM              virtual machine monitor to compile for (qemu
>> +                           or kvmtool, default is qemu) (arm/arm64 only)
>>      --cross-prefix=PREFIX  cross compiler prefix
>>      --cc=CC   c compiler to use ($cc)
>>      --cxx=CXX   c++ compiler to use ($cxx)
>> @@ -56,6 +59,9 @@ while [[ "$1" = -* ]]; do
>>          --processor)
>>      processor="$arg"
>>      ;;
>> +--vmm)
>> +    vmm="$arg"
>> +    ;;
>>  --cross-prefix)
>>      cross_prefix="$arg"
>>      ;;
>> @@ -108,6 +114,10 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>>      testdir=x86
>>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>>      testdir=arm
>> +    if [ "$vmm" != "qemu" ] && [ "$vmm" != "kvmtool" ]; then
>> +        echo '--vmm must be one of "qemu" or "kvmtool"!'
> nit: I'd drop the '!'
There are two error messages following this line, and both have an exclamation
mark. I would like to keep it as it is for consistency, if you're ok with it.
>
>> +        usage
>> +    fi
>>  elif [ "$arch" = "ppc64" ]; then
>>      testdir=powerpc
>>      firmware="$testdir/boot_rom.bin"
>> --
>> 2.17.0
>>
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
