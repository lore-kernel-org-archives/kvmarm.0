Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28153C13EC
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272829; cv=none; b=Zvv2F8/DkVHIGi6iBdyhewmTeD7nLAGCh/5kecpGOq/gs22basAcy00CDaf1vDWyZSK137SRbRXPRcJhjHH6dfICKeNGsupr1LW7JmSiSYeANloi6bj2TIf2IO2vuZqOMp+I9yK1IW9nT312o6b9rCCWd8QSvhEj7WM8zGQ164k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272829; c=relaxed/simple;
	bh=dIEo2BWot8KMA7bFyxIXMBMINiO703u3CNAgbTnUo2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHghG8JfdD3BnjYngZQCGFe7FUWOuky/PdTgGq4DBqaQxfNcxBr/RicbFT3gSIdGIU6BQ5eWgD/OEHyDmen2BZDJl3XIZdjoT3DOsWV4RN8mJIy1gNw85MUFZ8XRrrTIGf2zcN8LDF2gurqDRjNd7gcMM1UOMiaoHkhLoI7t90A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=fiKZiMP3; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="fiKZiMP3"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52fa9c055b5so11364471cf.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 11:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790272822; x=1790877622; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yIrEACM/1hk8RvSSdnwytl7iIy1+VcppA4PP9Tt2BDk=;
        b=fiKZiMP3kCg0rCqAS7jNoOQqvaLmF1lQ871Nm7yG1ihtXEqW+V5/safVBeYTNgx9Fx
         rE6X6ezjhiZpCEy8yAdiFelbQCnJQ5FBStQ45hZX7l+QqKhGxE6Op1DzNoHcglEkbIo5
         r35zu21N7JP8iVjkzVTP+V50i+Te59VcVMfnporEK+5HHr2277UVMenVXhaQhLz/jKK/
         izSAT4CVvJC8zcCpmptFICmgC4ZqUETZeI0qCM6nPvxpHJSfJnLmz0gwsaIan6CD2kiu
         GEM6qYccRSp3PlbZFTmb9VF1P1yWglHRG286Vv7E61hI+dDDH3WszOIn5UFHwjnivUBl
         141g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790272822; x=1790877622;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yIrEACM/1hk8RvSSdnwytl7iIy1+VcppA4PP9Tt2BDk=;
        b=cksQh6DhTzrPVgHEZfw+9lyxmfTzeeldy2mJSHyuJa8GZ0d2VpooyOuSZe+y6fitgs
         Poex9B2yAC5dSJvpD4zFVzW8mI/MZ3S9JcKVq870eAcnMFTBOgWjr2VvygvSihMe3XT8
         cHpnImvjtV4sQCb1GFJkviazptjKt+QokVL+Ntd3Iv93bsICVyIbboo/G6CO88jo4ntc
         N9F5eyujSyGe6on2QTCo4Oh8ii8jWbZL3ThvWMw0kG/1tw+GJdFhA/6wYl09MvpOj+SY
         jtzE/J6Ff9SoU8WerBZJR9mtpz/emcPLmdixCIRq0VKkUxAar6qyl4AUR9xRLfV4CD0W
         U3xg==
X-Forwarded-Encrypted: i=1; AKwUvBwdPkWqqwE7z7gl+2i9ESntfkAEeVNf7PnIVLNnoXZYMXXApFbc/3UzZ3XdkRf9elYotmGBB20=@lists.linux.dev
X-Gm-Message-State: AFuF++myRwtFztsvadtVMdPtF0ntz6tSWaIbL+vmCyOSEKfCAJKsf7P1
	+aQbkVixXIkaAkwZREw56PySkd4uY3Hd2YnsXb7UlnXp15SXYQm5Znv7tHwxKhXAYkc=
X-Gm-Gg: AYBFou3sCXFpwccpq+CibUrAmghHKcwVyiEOReSAW6bIxQNx5y6tbzJ9VfiUh2Zwu5A
	vN3y3OQITjyJNpfoSZxayFOxmtTv5fMHLGUxwWUTGATh57ESp9x2f/zuS/Ayx3wdhnMA6txHYG8
	VbjSeguaLkIRt028bQRdy4osCBrpzzqYaqI5hmkyQl7CQYpImNDwn+QmO82qQTiF7Ssh0xgnf1X
	8joLoOBgHw4D92o6sEnVRb+oiPeNG/j8KK2zCmeKfWl0+NpPQXDTLNxpAKfCmRSP9E2eMUhQRTO
	uwHeA1hASfKB693V8hJyEfn/3Tmr44eQRt6EPev5q6d0NKIQuQvr1xQ2jiNGCSzdRIyG8pRqT0V
	R5G5yTwQiAdtMdvxslNTCt5O8UxleG/UnBXWy8zgE7CNc33O/0hsI3Pez47vefYlra8xqGRhSpK
	b20XZxbRzNcM1C4wdc43CZoK8e9VBoIjl5bl1BFSeTEyR/2DmT4F6Ez0QXFX9sxE29CGjpaZenI
	/ZXbcSU4zoR7gtvGiVA2MThDGpmJf30aNevRY6F90iHcRHF1BcpLu0=
X-Received: by 2002:ac8:5a46:0:b0:530:e682:87c with SMTP id d75a77b69052e-5330b6df434mr78501cf.33.1790272821894;
        Thu, 24 Sep 2026 11:00:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb38d347sm47450101cf.25.2026.09.24.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 11:00:21 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:00:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Message-ID: <arVkwC_wNoTLjRYf@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
> 
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
> 
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
> 
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index d6ed10cefc8f..62f2ce1ad5a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>  			  const struct vm_area_desc *desc)
>  {
> +	/*
> +	 * It is not valid to execute mmap actions for VMAs which can be merged,
> +	 * as any such merge would leave portions of the mapping incorrectly
> +	 * unmapped.
> +	 */
> +	if (vma_flags_can_merge(&desc->vma_flags) &&
> +	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
> +		return -EINVAL;
> +

If you wanted to make this unit-testable, you could pull it out into a
separate function:

static bool mmap_action_is_valid(const struct vm_area_desc *desc)
{
	return desc->action.type == MMAP_NOTHING ||
		!vma_flags_can_merge(&desc->vma_flags);
}

then write:

if (WARN_ON_ONCE(!mmap_action_is_valid(desc)))
	return -EINVAL;

And you can write a unit test directly against mmap_action_is_valid

otherwise

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
