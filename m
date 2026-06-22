Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970E02D5A19
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 08:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117233; cv=none; b=tVZYKgSWzzK+xy/2fGZqMTckYiXq7FDjO1meTr+gA5Ees9Q5H5w0mj1tbQ7Irg7MpF+mHqDVmaNrobY6rzttH+cr4pMLt3cIYUcRB+0a6JgSFVlhxyq6sfdZUDP7KfBCCg3BqHSsTaku3N9nxZD0QVtGE/m/y+mm+fDlmWm+dmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117233; c=relaxed/simple;
	bh=Nw+KP6Gua04EKOL1i2bS7/ZOL0AXmIEXXmRC1yahR58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fwtpEl+s+Qg7F8ZQKLLxg/hVyh8Nx6NlDhfEGfyyOGI+7XqJAoCVrt1JIh8yHlexTn9aIuZMrvUGRn1ytScn8j49fzwC5NdDdvlvBqGV3QIBLG2V7RUudJj7v7VtvVG7guOEY4IqS0jnnbZbMXO6F6JyTA4jYIohsnriOoJGKuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tNwtD65N; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tNwtD65N"
X-Forwarded-Encrypted: i=1; AFNElJ88dQhQ5Q0XN14LQpEc5bYmsBBqwLT8VGjxuBpyjxL6Y4v42geeqWwaaSfbSPTDTh0qImv+Z90=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782117230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LMlv5sWG4rQ4mDu/88J9tsbgaPKRoMu6C9AqGqZiHXo=;
	b=tNwtD65Nzrw87R1CPP+MqG1GVoLe3sR2mkeEi3JlcdUWdsnUYYBEEzNW6hhz0zARR4sz2o
	V+62PfnnpoYc1jd9hIxY12a1wjHaeQ40EvcFMZRJ/bxiwDYZdYtY6qN4Ve9GVzE2A7+1Eg
	xVCRhGTtE/ZMD6wRZKAdK9x2hvG+jmg=
X-Gm-Message-State: AOJu0YxYA2isa3g0an0IIzkdnvY/IO2qBlHgWuCo5fE4hmimMpXJd61y
	E+lyUd6TMHbCvIKaoxgWukAIapG70IGOlGZNdUhDretS6IP9wvIduZavA3mAN9jL2pcNAulpgjp
	A8ic4RQG8g7Wm38wYTTEH/bHd8F6iW+6nOmxtJ/Bf
X-Received: by 2002:ac8:5812:0:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-519e8937418mr20106801cf.15.1782117202105; Mon, 22 Jun 2026
 01:33:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621213155.6019-1-include@grrlz.net>
In-Reply-To: <20260621213155.6019-1-include@grrlz.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 22 Jun 2026 09:32:45 +0100
X-Gmail-Original-Message-ID: <CA+EHjTztL4O6NH-sNpPywchgER6SswetOCgmaaSGjtKaRtL8XA@mail.gmail.com>
X-Gm-Features: AVVi8CeGmftOBXIGaXfHmUYTToXb3vtN5VWYlAu0NuHDiDaZP2CXGjkjPm4EAHs
Message-ID: <CA+EHjTztL4O6NH-sNpPywchgER6SswetOCgmaaSGjtKaRtL8XA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
To: Bradley Morgan <include@grrlz.net>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Sun, 21 Jun 2026 at 22:32, Bradley Morgan <include@grrlz.net> wrote:
>
> Protected guest faults charge long term pins to the VM's mm. Teardown
> can run later from file release, where current->mm may be unrelated.
>
> Drop the charge from kvm->mm instead.
>
> Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()")
> Signed-off-by: Bradley Morgan <include@grrlz.net>

Reproduced by creating a protected VM, running the vCPU to fault in a
page, then forking and having the child close the last fd reference.
Without the fix, the parent's VmLck leaks (the reclaim decrements the
child's mm, which is freed on exit). With the fix the parent's VmLck
returns to zero.

One minor observation: account_locked_vm() also passes `current` as
the task pointer to __account_locked_vm(), but on the decrement path
that is only used in the pr_debug log line, so it is technically wrong
but functionally harmless.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/pkvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4b..428723b1b0f5 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -352,7 +352,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
>                 page = pfn_to_page(mapping->pfn);
>                 WARN_ON_ONCE(mapping->nr_pages != 1);
>                 unpin_user_pages_dirty_lock(&page, 1, true);
> -               account_locked_vm(current->mm, 1, false);
> +               account_locked_vm(kvm->mm, 1, false);
>                 pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
>                 kfree(mapping);
>         }
> --
> 2.53.0
>
