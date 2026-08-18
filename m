Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A039A7EF;
	Tue, 18 Aug 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787041414; cv=none; b=UlM5j4rCR/UiTeDKQBhPp/CY6NTdIyLINnqvvMt3Ue3WBtH2MilKSLi2u8Sl5X7awer1wFBc88fq1L/mp9nWAwFHAG79VYGatuJ1TETxHrAr95tN2FcIB0cR1JQmPprVafwU7OqeN0r0ze8jz0A/pyzsq1/CBYTUecmpoO0DAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787041414; c=relaxed/simple;
	bh=fQ01i/t0oVTN8tCjuykIg6sG7mAieYBUPDTtleKJstg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XJ43E2Fe2fA1KQhGhoKiadWpa+wKt9MnUBN2rbTjgwwhV2lcAIryEY4irn469xbGe6Rb5a9zb4Zkp3SHAfMfPcJ6nKd50PbaRqLM//QW7TZ65yE4ApPzjKplfyLFX0o+ywTov6zezdZ30firPYB5QQMDbDK72YVFzdiVaurSZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+q25K8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+q25K8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9761F000E9;
	Tue, 18 Aug 2026 08:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787041412;
	bh=bNoYo0rsKZV3ZNi6/1Gy26/IaeGszAoL9DmLiIJFKWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+q25K8u4AdnTaMbo70X5Jc0M2w00UNg0LKFGEd8sOV2Hn1Fo7kd7otFKqlA/AvMC
	 9RmJamsN8yPzoLo0EMhkNSnLZ31PMhMu6K2+6HbDVhaJWBzy1mHvTTVUq6APXcglkZ
	 qqK74vxxN6EL2wjPwI/DbCxU+c3d6/hGOHFB4Xg8gvNcEG2rYYy3xBi9/oosk8yPv5
	 IUMqqmFU8v2inQa4c2x2mAKVT9AAzHMKHy+BguX7vhJxyVIiuehp0ZR8s4DcfcMhsz
	 qkOS25GNEy7uoADdbHam00TASRV18jIzKim86cHkEv+B9oUEAwVraLopoE2mfK5sG1
	 XXNU5246zIo/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] KVM: SEV: Treat unassigned RMP entry as benign race
 on PSMASH failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260818-gmem-no-return-page-v1-1-4f8d939efdbc@google.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-1-4f8d939efdbc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 08:23:31 +0000
Message-Id: <20260818082332.5F9761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] Unaligned GFN range in RMP fault handler causes erroneous invali=
dation of adjacent memory
--

--- Patch [1]: [PATCH 1/4] KVM: SEV: Treat unassigned RMP entry as benign r=
ace on PSMASH failure ---
commit de1b2dc6f988d4cc54c9ff854b0263fe60c82d44
Author: Ackerley Tng <ackerleytng@google.com>
KVM: SEV: Treat unassigned RMP entry as benign race on PSMASH failure

This commit modifies KVM's handling of RMP faults during a PSMASH operation.
It updates the RMP entry lookup condition to treat an unassigned entry as an
expected race when re-checking after a failed PSMASH, preventing unnecessary
warning logs if another process transitions the page to shared.

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fcb41dfde4c02..b2738362a928b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5074,10 +5074,11 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)

[ ... ]

>  		/*
>  		 * Look it up again. If it's 4K now then the PSMASH may have
>  		 * raced with another process and the issue has already resolved
> -		 * itself.
> +		 * itself. If it's not assigned, then this must have raced with
> +		 * another process that made this page shared.
>  		 */
>  		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> -		    assigned && rmp_level =3D=3D PG_LEVEL_4K)
> +		    ((assigned && rmp_level =3D=3D PG_LEVEL_4K) || !assigned))
>  			goto out;
> =20
>  		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN=
 0x%llx ret %d\n",
> 				    gpa, pfn, ret);
>  	}
> =20
>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);

[Severity: Medium]
This is a pre-existing issue, but does this correctly align the guest frame
number before zapping the range?

Looking at sev_handle_rmp_fault(), the gfn is calculated from the unaligned
faulting guest physical address. Since gfn isn't masked to a 2MB boundary,
does adding PTRS_PER_PMD cause the zap range to cross into and erroneously
invalidate up to 511 pages of the adjacent 2MB region?

Additionally, if the NPT mappings were already 4K, would this unaligned gfn
cause the function to miss zapping the start of the intended 2MB region?

> out:
>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-re=
turn-page-v1-0-4f8d939efdbc@google.com?part=3D1
