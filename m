From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH kvmtool 5/6] kvm: Add arch specific reset
Date: Mon, 17 Dec 2018 10:25:07 +0000
Message-ID: <4ab9d2f2-a73d-517d-d1d9-d816bd81e5f6@arm.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
 <1543922073-55530-6-git-send-email-julien.thierry@arm.com>
 <20181214181124.5374b2d0@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 587044A375
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Dec 2018 05:25:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C7aChpqKS3Qs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Dec 2018 05:25:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B966D4A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Dec 2018 05:25:11 -0500 (EST)
In-Reply-To: <20181214181124.5374b2d0@donnerap.cambridge.arm.com>
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
To: Andre Przywara <andre.przywara@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 14/12/2018 18:11, Andre Przywara wrote:
> On Tue,  4 Dec 2018 11:14:32 +0000
> Julien Thierry <julien.thierry@arm.com> wrote:
> 
> Hi,
> 
>> Add a callback that allows to set arch specific default values when
>> creating fresh VM.
> 
> So is this needed just for initialising the LIST_HEAD in the next
> patch? Can't we use some dev_init() call for that purpose, or even add
> the nonvolatile memory device to all architectures and init this in one
> place?
> 

All the *_init() calls are done after option parsing, so this is not good.

And I'm really unsure about adding nvmem for all arch as:
1) I'm not familiar with the memory layouts of other archs and wouldn't
know where to map them.
2) I wouldn't know how to expose them as not all archs use DT (currently
only arm/arm64 and powerpc seem to really require it).

Or we could introduce an ARCH_WANT_NVMEM, and CONFIG_HAS_NVMEM. And when
this is defined, the ARCH is required to provide an NVMEM_AREA when they
want to start using ARCH_WANT_NVMEM.

This way there is a base for other achitectures to start supporting it
but avoids me breaking their memory layout or introducing an unusable
option for them.

Thanks,

Julien

> 
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> ---
>>  arm/kvm.c         | 4 ++++
>>  include/kvm/kvm.h | 1 +
>>  kvm.c             | 2 ++
>>  mips/kvm.c        | 4 ++++
>>  powerpc/kvm.c     | 4 ++++
>>  x86/kvm.c         | 4 ++++
>>  6 files changed, 19 insertions(+)
>>
>> diff --git a/arm/kvm.c b/arm/kvm.c
>> index d5bbbc3..1a2cfdc 100644
>> --- a/arm/kvm.c
>> +++ b/arm/kvm.c
>> @@ -57,6 +57,10 @@ void kvm__arch_set_cmdline(char *cmdline, bool
>> video) {
>>  }
>>  
>> +void kvm__arch_reset(struct kvm *kvm)
>> +{
>> +}
>> +
>>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
>> ram_size) {
>>  	/*
>> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
>> index 1edacfd..eeeb10c 100644
>> --- a/include/kvm/kvm.h
>> +++ b/include/kvm/kvm.h
>> @@ -136,6 +136,7 @@ int kvm__enumerate_instances(int
>> (*callback)(const char *name, int pid)); void
>> kvm__remove_socket(const char *name); 
>>  void kvm__arch_set_cmdline(char *cmdline, bool video);
>> +void kvm__arch_reset(struct kvm *kvm);
>>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
>> ram_size); void kvm__arch_delete_ram(struct kvm *kvm);
>>  int kvm__arch_setup_firmware(struct kvm *kvm);
>> diff --git a/kvm.c b/kvm.c
>> index 7de825a..05ad0b6 100644
>> --- a/kvm.c
>> +++ b/kvm.c
>> @@ -158,6 +158,8 @@ struct kvm *kvm__new(void)
>>  	kvm->sys_fd = -1;
>>  	kvm->vm_fd = -1;
>>  
>> +	kvm__arch_reset(kvm);
>> +
>>  	return kvm;
>>  }
>>  
>> diff --git a/mips/kvm.c b/mips/kvm.c
>> index 211770d..3f6fd20 100644
>> --- a/mips/kvm.c
>> +++ b/mips/kvm.c
>> @@ -56,6 +56,10 @@ void kvm__arch_set_cmdline(char *cmdline, bool
>> video) 
>>  }
>>  
>> +void kvm__arch_reset(struct kvm *kvm)
>> +{
>> +}
>> +
>>  /* Architecture-specific KVM init */
>>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
>> ram_size) {
>> diff --git a/powerpc/kvm.c b/powerpc/kvm.c
>> index 702d67d..5bb721b 100644
>> --- a/powerpc/kvm.c
>> +++ b/powerpc/kvm.c
>> @@ -87,6 +87,10 @@ void kvm__arch_set_cmdline(char *cmdline, bool
>> video) /* We don't need anything unusual in here. */
>>  }
>>  
>> +void kvm__arch_reset(struct kvm *kvm)
>> +{
>> +}
>> +
>>  /* Architecture-specific KVM init */
>>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
>> ram_size) {
>> diff --git a/x86/kvm.c b/x86/kvm.c
>> index 3e0f0b7..e017d36 100644
>> --- a/x86/kvm.c
>> +++ b/x86/kvm.c
>> @@ -129,6 +129,10 @@ void kvm__arch_set_cmdline(char *cmdline, bool
>> video) strcat(cmdline, " earlyprintk=serial i8042.noaux=1");
>>  }
>>  
>> +void kvm__arch_reset(struct kvm *kvm)
>> +{
>> +}
>> +
>>  /* Architecture-specific KVM init */
>>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
>> ram_size) {
> 

-- 
Julien Thierry
