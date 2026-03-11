Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5E9282F2C
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773233404; cv=pass; b=ecmwLeEHwh8uddtkdOsTzX4BCeb4cnsSRFpxsZl98bwMylme8D3MlmaSEMSKu8nDN3VpG9LwR7CJHOf0fJBFAeRNIsEZBNaKSUWf+8Ui+Uisthe9y0sPoppg2NyUKg2yEhBhlnlRZln20LagUUmkPaTeyXWCDpc8J5z3TfNJWx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773233404; c=relaxed/simple;
	bh=0hh7rCZjvdGitv9p8epAfcnaEGtqwqWbNOA+Hfpo9ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G59ypX7A+dQ08FFUXCNpmn5iyaCrzDdXb/s8O1WTs3D980QiKFcENAhuKkniuPfx7NuaG0Sv2Dn2fGNfqnrS4ynVUBtoKp28Dj0PjHnRdL8DZV2uTVvv7vqeJKAy2C9vhDStq4tRbtKpz/bscXYS0r/1nvcWtZdJ41ivoAXQ4pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kYyjuPX5; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kYyjuPX5"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso474071cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 05:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773233402; cv=none;
        d=google.com; s=arc-20240605;
        b=WIu0tNyQqnlGH36aoRjszOFH+RAuU5yKdzs3ybnNClJvqX3FOI3y8WAJf/i4JVH5UR
         QhMSjGR5/s5kZclvGX0QlFcylwCdK9E/96QVdaMHSU9DVdDZKSF4GCfzvDZ7+GT1M8gF
         ms6igLusXoWGS/3HHnLNewmj8Ma64Skz7VjbuCOJ7UW3TW+8gap7TmP0WV2WPFCpqGoq
         ctfJEe5a+MHiUOtgbwgRr4zELEkD+XlS05om9q3158srWifHTFk9R9rYUBztC+2kmr/Y
         6SrM+yEwZGPIukAvS7/gsoBLtQPntoPhxZPLEKTGd0YNBFbbVcJ5L7IwbcPIVZH2Q52n
         5jyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=y2MGgBYTaEO28Ct4I8jS2apA/t/hDq2a42kL+JCrbEY=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=SsLjox+uRye47eDoOBtQYev7mgumPcDA2+GGMJuz4TPXzID2eDBR6cvfMdj14aCWyC
         JdrOIPMkKt0K+ungS178t1zFQQeP7T/yss7ZpVXjmRhEz8fceUUU5Wx+Kwt9v3r5B00l
         9kNcubLEtAG/3OJvDURPL9eG66tWLEGkDkCIFvNKltITb5vyFQzX0ltlrBTjVtTqY+JO
         s/RThwizSTZ49XF6kiGJiubiUJSJ+Hh5VMWZdHHnoX9OZMk0dKeNYoVDb+IiKSneih6R
         ykylvX4SJajmFYH0gAimX9YhfC4lr/1AZwl6yxHujMOpsQe5jPpI1w4RQQ8TPCWv6O7O
         nA6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233402; x=1773838202; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y2MGgBYTaEO28Ct4I8jS2apA/t/hDq2a42kL+JCrbEY=;
        b=kYyjuPX5PC2bSTFbcBGq+/GNm7i2dioZPm1O8UaxDdICzM28GO9fUzn+I3e7xTYolq
         FgsKtR8338LvSvERGwM9Wb2Fzgp2qoA7qE/2xfARY92K1+UxCzk0NoXoFdqyJuI7VWki
         YJ+2t6M23rZNntY7aB1qf96SIPfx8Z7q5tswL/73JKS0oi60TRwNzkGsAThZajlgzEFp
         bwXEtZpfiT0zc8e169UjKyVbPqrZVk1zkdYp4idFW3i7pohFCinYp+myZJP6vwSttTZL
         HN/BsT3aSWCA/3+JEUOFRP5eppxxCVkCC8vLkRA3gGmytB9KTqWU1q4pE2GXAqgPYXhe
         HLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233402; x=1773838202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2MGgBYTaEO28Ct4I8jS2apA/t/hDq2a42kL+JCrbEY=;
        b=oj6/CfuVjYdnMXT12ugpm5WFRLl9M46zgGP/KuCpqJGNIzGH5af2NhwciCkXeSEZMP
         ymO0MVPeOLJDICId0y+goBD4PduYs2xov8PIl1IsXc80SopDBBE8WXkFPtiuwieG+7R6
         5d9iElVm2a6iBj2UWchobKbPtFB4v5SMipbAs8omneqkldfLFdVWYyq3kQCeGR4HRSsW
         vVVZW6NOD65pHbjLivnEYzxLs+1rVXxh5vHk1D7i1DEzvZ8X0h0lMdPdsfIvC2hkouLe
         tmFb4ZbDTtnPZHCq2kgtQvKizTf7pDUnKpXwc+GE/mRTcXbgPiK1DWW4qS3VKTs/ux16
         Fp8g==
X-Gm-Message-State: AOJu0Yyhz8S1qAdE4WdKKUxbqxDxSIiHtzGbFLaMKEQ4giNUuDm25KbH
	Yfovo0mV14Vy8R5TC5rraUCICNiP1CN5K1E0QSVodjE4uieJIFWQ6g+coIOQrE81MXbpDp4hkLh
	tKPUo1wlGTO3UFD9gmv6c8yedxXABRMATY1BDp37F
X-Gm-Gg: ATEYQzzwanYhSfabsOp6vqcisR/D0GmkjLi3kuCFiqij33cNsl/vwVTXhR4K1hdJG78
	nzvDq0PTy5VK6ZO3pi5r7zektPsRHglRxPMAMt+DDq2PzPZHctN2TUVCMD/Mun7ClUMhvJHvhLk
	ujrAAGMY3kEAR8IWak3TwWZrke3tiXf6oUkQ5iS/Z68rDNlf2InF436NRODncdHDnbtxBrzw+26
	+RTb6/agk1mxCdaS5lq6G+eITvvRCVEV8oABR5QKqRw58BPokXQKstPRYIP3cFtX2DWiWhdBWtZ
	AYlW+tjW3soAcHOzwoU75VOnxKvE6B4Il9V4YA==
X-Received: by 2002:a05:622a:285:b0:509:15b6:f69f with SMTP id
 d75a77b69052e-509381899c3mr12930681cf.2.1773233401760; Wed, 11 Mar 2026
 05:50:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-4-will@kernel.org>
In-Reply-To: <20260305144351.17071-4-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 12:49:23 +0000
X-Gm-Features: AaiRm50zL21Iu6bgO6eh5nslf62hR-XP381uJXsn-8C7zkK1BYfoGCC_CzNKrWU
Message-ID: <CA+EHjTy3ipkQ+h2h5acbJSJHMe-aPw=Ai+g74vgRi3mRSK_Jvg@mail.gmail.com>
Subject: Re: [PATCH v3 03/36] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> In preparation for adding support for protected VMs, where pages are
> donated rather than shared, rename __pkvm_pgtable_stage2_unmap() to
> __pkvm_pgtable_stage2_unshare() to make it clearer about what is going
> on.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/pkvm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 7797813f4dbe..42f6e50825ac 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -322,7 +322,7 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>         return 0;
>  }
>
> -static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 end)
> +static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64 end)
>  {
>         struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>         pkvm_handle_t handle = kvm->arch.pkvm.handle;
> @@ -350,7 +350,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>         if (!handle)
>                 return;
>
> -       __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
> +       __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
>
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> @@ -386,7 +386,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                         return -EAGAIN;
>
>                 /* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
> -               ret = __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
> +               ret = __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>                 if (ret)
>                         return ret;
>                 mapping = NULL;
> @@ -409,7 +409,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>         lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(pgt->mmu)->mmu_lock);
>
> -       return __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
> +       return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
>
>  int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> --
> 2.53.0.473.g4a7958ca14-goog
>
