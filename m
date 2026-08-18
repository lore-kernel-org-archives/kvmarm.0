Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB4449B12
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046277; cv=pass; b=V1YxChzkBoMtsg/vNKhpkLr2SLQNVw0EhAdkz0Qnlt1cP1fFvL4uxkM9J9ciAuN+1jM2Q5lxbjiT98WyBExa0zAtK4914FhLtCSrWv9pyvbg4rDDIoln2BhOSSmDGY31zkCNPfbbJxSFSZ52p/xbtLOIYAG7K3k+2CDmnmx7uEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046277; c=relaxed/simple;
	bh=7WABSuV4sFXi9VKk+Z6H39gC3g1G29463lKuZYgZWTA=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=md69wDKE35N8hzitw5MNCYrYQHJZVD1DH8Ig7L0MiAPwGQPRdKyjG7h4d/ah/UnhadijdDGMscfU5AsqQeH8KgB2ZI5SUDPW1MMBxmq1JS3ttK1sj94ovO5BgEUQxPa29sUlUHyZ3FqNQx8+TjC1TCXXSc6VzeRnmkIYo7TGMvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jmgCbAo1; arc=pass smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jmgCbAo1"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c9ef3e1337fso3557044a12.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 02:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787046275; cv=none;
        d=google.com; s=arc-20260327;
        b=T3pXv9IJYjipnlHr/2JKMkH9H7IDWr54Dsbyvlor8KaE7eoA1OTKd7mJ1egQnSI0q2
         K7ncEkckDdKmanwMXhCPiT1qvtak0quQpHeZbCHe68cyKd/8G+Nh9h/Ckn1dbnuoKoQk
         tNGp6jRcZq8Dm4eQk+T3DsBob5cnsLTzkjV6aFY0rbUyP3Z4oRv0kNqJDs5tQ+qD0y5k
         qHVEDOOoYTFkBaO5lhig8S5lxHAELbbmNLyWYqtuUcCjXV+IwtNlfB1JJpwTpHSvKQzE
         uSO3qcekYAJy7DwXvLGrVUzK0VS3ncYNQEkXyzXJbInmrmBX+DN6pDnIZkQpnL5obwQc
         Cl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BeFyeN+d7Fl6w7s7F00mypvhcoz1q5bXaJcc27nMLck=;
        fh=zUNjUZ4nobfVQfUDXLC/AF8P2MMVca0uP+Mbx25PfdY=;
        b=iBzp+69mgnCIks62lMZlcbXZ93BZHJOs8HH5t9a71U3e89GX5xadmAvNVnXaVk1vHo
         EVU4v1jaKXr0ywUmx5ikvs29opykSaUs7t1Oa3qlP/SpTtQuYljSup6H3RbrFdn1nXbn
         uwxkAKU2dmMcRFa2GRiZVnhA1ZPcT4U2tVgD511EvspW8BR68j8EyM6C9edU0JLJ2OtZ
         1VS7+N/V+hwaFF6oi4car4OuNlF0YIwFY9GIXzK0cxTUZBxSIub71ZD2NWXap6rHetnF
         5HBJU6GjMFp96IEldCNmE3ILExfg4+D0s40/E0r182IRkE/2MafjeB6pWRuyr5HoWxb1
         Gc4g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787046275; x=1787651075; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BeFyeN+d7Fl6w7s7F00mypvhcoz1q5bXaJcc27nMLck=;
        b=jmgCbAo1rnmbcimv4MefoFJYcCcXv/3GM0M0xuMGR41N+eVDCHqb3DyYO15Na0ScM8
         ixufVn2EGsBwf0vCS91hA+Ptk/IFsc4Wzd1tIvNlK/68oyvIO6YiusvvoB+x3nFGUfI4
         EoM3SgahzDQ46SOVKPL3PKIhKzMzChaulBJ9cp8hKQo3ZYhCJOsCg7PJbLrROZALS8an
         DfBYq7Zp44+byhJtabt8LvkYgCw7VW1YntuY8ZF7ypUdkR/Uv1XKNYQWJLpUvL031yLt
         s9Dep0Y5NbytHVYxY6fZm2RNzOPFogQltX0yj8ZCT5zoagz2p9kBgwQsI9PEoGzNhUVK
         mc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787046275; x=1787651075;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BeFyeN+d7Fl6w7s7F00mypvhcoz1q5bXaJcc27nMLck=;
        b=nq10yAZKWtBG/or5y4PZD41lF5XZKmWJIs0wRGZi7d3xLv5uN0hz3AXQ2/1jWXGtuK
         ytDxliOJL2tT9cEab1RAngqFBnVJVXoHCQPeZGUrWa6Nfx6iHwvdMye/XN1W0tQE00C0
         ekBBkiD+CfcxodMF1eHccoy5Lh6A1nzOr+c/8LBpXeBZgMzTibTpUEhvr2JmB1Y8BkbE
         urmhbAgSmXbGMrzMwKbTwvbNsgDEk2L9rlE/vuJBgS3J7fjPeK89vh3M09JIzm37kpPp
         Cd3ZgqlGPTq33HAGk3Vi96UiPWRz80LMI5BIsTSbooJ/rlogPJCnZxiNwOOkFkyeEeTO
         vOrA==
X-Forwarded-Encrypted: i=1; AHgh+RoCB6OkM0jeVEztubUJmXjkSJSFutYCPgxZMR3jtridLcapXkXwudmG7/VtowNoNV12dUBUTpM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdnmzI1y6/D4QQSiDSLc4wichgX9vr0BG0fRIvF9KrCpGrNXS+
	VbTmMZzMLlfx9kPes89fFq/j4iDZXkVl4alGFCuYfPIi78MVCL7u+kU5ygXX3SUl5+JGit2MPDb
	MlO7+nccNl5c/F9FVo3ZS+iDf4edjqC3qBMaGuPA2
X-Gm-Gg: AR+sD12+fXf9BXk80dCSmR7aJEuZ0wPKFJkWLlgz6PJfYscTSR+/3R9wzj5oysh2tfw
	1zJHfR7XUQaxc4/q2AhYuU4Uwr0XvcH4u1p0wWv366vvx888u6d8EECTYj69kZvC5q7XSAEM6rU
	dXGMZ6E9no+eGEXSGG5YIgZojZqUrRQ/+Z/PrXeyvK3OdY+jwXqdhRs0CtRi+qMSSdp1KsHg7Kl
	krrw0XI50XiX8FnGscjFYZKhgEx2JKog1fVhga87vmUA/dr5fUGwPP/k5ngqXZaThIZhMCK2O+8
	gK8kmrlHgrDA5t+5uQQID1XjKuk8jO5x/A/AIusvXmC6Dx5qU7FPQlrT99rskf0n0nxPx5GDMOK
	DpM4rVpf85rNoAG4=
X-Received: by 2002:a05:6a21:3103:b0:3c1:fbf:1e2e with SMTP id
 adf61e73a8af0-3ccda9ad8e4mr10134494637.10.1787046274831; Tue, 18 Aug 2026
 02:44:34 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 02:44:33 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 02:44:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoQZFtSd671ti4sr@yzhao56-desk.sh.intel.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-4-4f8d939efdbc@google.com> <aoQZFtSd671ti4sr@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 18 Aug 2026 02:44:33 -0700
X-Gm-Features: AcwNN1U5ehd_NTGTo4zZtHEtfJhdWWWuVuXA16suZpoLtMBQBlqamb-zw5aEarA
Message-ID: <CAEvNRgG8gxZSmOrsENemNqbaZuDyqNXj35M4VyChA6HQ_ofYVg@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: guest_memfd: Stop returning struct page from PFN lookup
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> Hi Ackerley,
>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 6c941aaa10c63..e5d637a5ec558 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1613,7 +1613,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>  	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>>  	unsigned long mmu_seq;
>> -	struct page *page;
> Just drop the page should be ok, since
>> +	struct page *page = NULL;
>>  	struct kvm *kvm = s2fd->vcpu->kvm;
>>  	void *memcache = NULL;
>>  	kvm_pfn_t pfn;
>> @@ -1641,7 +1641,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>  	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>  	smp_rmb();
>>
>> -	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
>> +	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
>>  	if (ret) {
>>  		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>>  					      write_fault, exec_fault, false);
> here missed a hunk:
>  out_unlock:
> -       kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>         kvm_fault_unlock(kvm);
>
> I will fully test this series tomorrow.

Makes sense. gmem_abort() is purely gmem and there's non-gmem path to
fill the page pointer in, so the above is correct.

I'll not be respinning again today, sorry about the flurry of emails!
