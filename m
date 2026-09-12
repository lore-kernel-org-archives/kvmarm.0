Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5261BD9C9
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198512; cv=none; b=k63cVvVy4ye9ZJrtqBOPmKHLA19ehs6q3X9393ejQwPDeZV9i+FPrHJrOGST23sZMdarEfXZBW/0Z31YqaCzirLz7oDWsgtErW+BodzcMhFxNBBw/gBSt/U7Ho6h6LZ3WA1MPuHMjw6+M4oWiixr5XVKTVH+iByUEZVm7njoys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198512; c=relaxed/simple;
	bh=neZ8RognBeJaJSsLpdLoPZIXCkIs4BzPH/m1sW5yZ68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uk8Fh3WyCxqmE6JSw+lg+1rIZGO+/oGzNFIYKeMRudu/X4WRv9I0gnaqaeIo3Mn4V4bLBq3cxhjeRQvwIqZN9UIiVu1ILqz8yYRfbfkkVvmosicGHrJcKjA9A1bOUcutQDqMn8NbPpzgGm31HSD0+WVfmR1NjOfMH95ktVDxEOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gnGQCFmC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gnGQCFmC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6109B16F2;
	Sat, 12 Sep 2026 00:35:06 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60C203F7D8;
	Sat, 12 Sep 2026 00:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789198510; bh=neZ8RognBeJaJSsLpdLoPZIXCkIs4BzPH/m1sW5yZ68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gnGQCFmC7QkgG+IcmeZBzVmjrXhhsgUO1cVfYfcTCuwFxHTuYrfmdeS87yDmb2SR3
	 Da5ZlJSXbZbPyTbnN2ULqxTlRtXnBjHcYNwxS98HZEhC5KgD7N+g4yv7EbA6Ddi3Yy
	 PCW8BXh+gu4HKMpm5+ieu1wWYkYTygiF+lZdhlTE=
Message-ID: <15c60e02-e40a-42d2-b1f4-c58de2124e32@arm.com>
Date: Sat, 12 Sep 2026 08:35:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 2/5] kvm: Bound-check the exit-reason string
 lookup
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-3-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260831192406.1341841-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 20:24, Fuad Tabba wrote:
> kvm_cpu_thread()'s panic path uses the kernel's exit_reason to index
> kvm_exit_reasons[] without checking it against the array's size. The
> table does not cover every exit reason KVM can return, so a reason past
> its last entry reads out of bounds. KVM_EXIT_SYSTEM_EVENT and
> KVM_EXIT_ARM_NISV are both past it.
> 
> Move the table behind kvm__exit_reason_str(), which checks the index
> first. The array now has a single caller inside kvm.c, so make it
> static const.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   builtin-run.c     |  2 +-
>   include/kvm/kvm.h |  2 +-
>   kvm.c             | 10 +++++++++-
>   3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 81f255f..f36d3e2 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -298,7 +298,7 @@ static void *kvm_cpu_thread(void *arg)
>   panic_kvm:
>   	pr_err("KVM exit reason: %u (\"%s\")",
>   		current_kvm_cpu->kvm_run->exit_reason,
> -		kvm_exit_reasons[current_kvm_cpu->kvm_run->exit_reason]);
> +		kvm__exit_reason_str(current_kvm_cpu->kvm_run->exit_reason));
>   
>   	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN) {
>   		pr_err("KVM exit code: %llu",
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index a9376b6..8619070 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -255,7 +255,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
>    */
>   void kvm__dump_mem(struct kvm *kvm, unsigned long addr, unsigned long size, int debug_fd);
>   
> -extern const char *kvm_exit_reasons[];
> +const char *kvm__exit_reason_str(__u32 exit_reason);
>   
>   static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
>   {
> diff --git a/kvm.c b/kvm.c
> index 96583f9..b416f6f 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -33,7 +33,7 @@
>   
>   #define DEFINE_KVM_EXIT_REASON(reason) [reason] = #reason
>   
> -const char *kvm_exit_reasons[] = {
> +static const char * const kvm_exit_reasons[] = {
>   	DEFINE_KVM_EXIT_REASON(KVM_EXIT_UNKNOWN),
>   	DEFINE_KVM_EXIT_REASON(KVM_EXIT_EXCEPTION),
>   	DEFINE_KVM_EXIT_REASON(KVM_EXIT_IO),
> @@ -57,6 +57,14 @@ const char *kvm_exit_reasons[] = {
>   #endif
>   };
>   
> +const char *kvm__exit_reason_str(__u32 exit_reason)
> +{
> +	if (exit_reason >= ARRAY_SIZE(kvm_exit_reasons))
> +		return "UNKNOWN";
> +
> +	return kvm_exit_reasons[exit_reason];
> +}
> +
>   static int pause_event;
>   static DEFINE_MUTEX(pause_lock);
>   static struct kvm_cpu *pause_req_cpu;

