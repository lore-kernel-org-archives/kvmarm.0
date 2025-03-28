Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6DB19259E
	for <kvmarm@lists.linux.dev>; Fri, 28 Mar 2025 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743171544; cv=none; b=cRRvLfCvN1jIm/dItcoHK+d2Q82eROy0oRTBygdIv2+ovQMAP0K0YVqa11rbVQQxmF4ybWO/G2FK4hqvdb4Zq4aLE0yxJ6ghlgRFsInrAaB7oYIkUNersTUQxlxSDyiuCzWtg32jWV3SPOQmH/NLU3cekeNtMxpA6+cGvZfKsjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743171544; c=relaxed/simple;
	bh=nN0gpJelgd92014adwEpMLZN3nllcaaxAIztxgNBGGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHs3eVe5kxP78QdmXRJUwNuQWrb4CTftmqxjg6pPeIjClWYMp943vT8kjbwl8VmO17tNEodb37+iewcyasZ52k5KVxhvEcfxjbdluhbLNiOgLvs6sj35dIa/gdx3dMdid+2CpHJCgKUdl3pM7HDUm7dS1N7u1OhQIDsvnXkqbVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4M9FxCB7; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4M9FxCB7"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfe808908so64305e9.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Mar 2025 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743171541; x=1743776341; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DgKGnlqsv8JBCCBT4cAI1s7V8k61mCMe7HW1WOz7bZk=;
        b=4M9FxCB7oH4EtjPkutcKpTUyD39KDOGdzVv7vgR91nET7FWgQHAJwnhEZQNK89bUKH
         RrsSDySp97GKhTulZVSCWOn+sOUM++1U6U063+D9/YJbjm7OE23kYxIPUGxaOnSgzdRg
         Yx60wz8fTBzJ8FuJsdEA90CwrCePMpwIWDAmLqFLQlRJAFHvw1lE8EG4n7wYVx89W48v
         Ya/hVsLJLtmT4n2mgF4QWtATknvDfGOoWJ8Aq0/pv9Agk62GGiQJCk7nN+qc19nhsRDm
         xkK6NJiqleqOH3zENBzb85Pxnkl3gcLcm1k23vcTnBrbu4/5nlfURQsDAjtBgkpRBBa3
         guPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743171541; x=1743776341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgKGnlqsv8JBCCBT4cAI1s7V8k61mCMe7HW1WOz7bZk=;
        b=KeE50uhXHj+yEmLGrWTDA+xY4Ts3UmcKqzhFrhW3XbxhBRASnvd+HoEASrS/4SL1Gp
         Xy2wDya95zQklLRuhXB6xA5ouBIreWEPq9+lYKZUNt0QLA0uw+Mr5MdYfPSIRt7UDSAV
         zqvO1P0vA031Z0soKkHOxO99M1ljj2k4NTWarfRAiJYleyUEEVh+TDFDhOWxQrHcRsSe
         6m7efsgFkLL0oZwi7rQGZedpCs01Xhk1L56xLzZLo64DVNLh2s5UzJ/axvFfHz0LTWXL
         g7AUyDN6d3/4dCgvTB0WZF29q+cC3osw99gMKoyhzE5TBR83X4+HmiaQ3Y4jGveKMyLU
         bp6w==
X-Forwarded-Encrypted: i=1; AJvYcCWwAIa5OtWdvmjiCNSATGfNcmAxPHxKqYLf71WbASngp8EK31VaIdG6sUJ1g3z80h04xNmDesk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZnQVQW+aStcIh//eb9wI/DNewzeYJa+yJsLR8TLRcdHebp/A0
	yQJBYgjqUmCzurEA5kcLuxzx1H7QTV1z4cv1s+xRuSqlHNC34OkHp1rdBoflSg==
X-Gm-Gg: ASbGnctZcsAzbO34yrISuPwSXWuheRBviF91l0wm/7qb+5uVu1wSUPdZ0/UfG9dQPHk
	MtTU/uS5Es2Xx9uJoA1ifLAqwRaxNmfo/3UulJpoJPPrZx8I92WANrv0ozXphiggqgTBFBI22m2
	TRPVaK76DMvd4VeKK++553GvuQDR0u4V3MmtXyI6HFDfOX44Y0solrXO6DWXqcCxPC8UusjCyPx
	J5Uzybrtku2Mhst2PLGxnKDRvHc7vrFZMaYQTXJ3UkxkodTR3qOp8mjsJKf23zUtVnUndIYg3mi
	plPAtyqS9lbdPhAK5AwKtfwkjdW66YZol+P4ClmcQxaVf5OrF18yo11V0ZxkaUaWZJeHaE4uZtW
	uYnDlLqw+sQ==
X-Google-Smtp-Source: AGHT+IHxOKuumMNh+x8OQRqeAYCAeaAh/X2iaTKV9NNyWp8l9Mpc74sAcjSgUeJ0CBhJSW8k13LnEA==
X-Received: by 2002:a05:600c:4793:b0:43b:bf3f:9664 with SMTP id 5b1f17b1804b1-43d9182811fmr778435e9.5.1743171540532;
        Fri, 28 Mar 2025 07:19:00 -0700 (PDT)
Received: from google.com (28.140.38.34.bc.googleusercontent.com. [34.38.140.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b663573sm2853690f8f.33.2025.03.28.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 07:18:59 -0700 (PDT)
Date: Fri, 28 Mar 2025 14:18:55 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Quentin Perret <qperret@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <Z-avzxyyOiaIk3-C@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
 <Z-Qv4b0vgVql2yOb@google.com>
 <Z-UcW32Hk6f_cuxc@google.com>
 <Z-aKgXVjp4nNJcLd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-aKgXVjp4nNJcLd@google.com>

On Fri, Mar 28, 2025 at 11:39:45AM +0000, Quentin Perret wrote:
> On Thursday 27 Mar 2025 at 09:37:31 (+0000), Sebastian Ene wrote:
> > On Wed, Mar 26, 2025 at 04:48:33PM +0000, Quentin Perret wrote:
> > > On Wednesday 26 Mar 2025 at 11:39:01 (+0000), Sebastian Ene wrote:
> > > > Introduce the release FF-A call to notify Trustzone that the hypervisor
> > > > has finished copying the data from the buffer shared with Trustzone to
> > > > the non-secure partition.
> > > >
> > > > Reported-by: Andrei Homescu <ahomescu@google.com>
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
> > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > index 6df6131f1107..ac898ea6274a 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > @@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > >  	DECLARE_REG(u32, uuid3, ctxt, 4);
> > > >  	DECLARE_REG(u32, flags, ctxt, 5);
> > > >  	u32 count, partition_sz, copy_sz;
> > > > +	struct arm_smccc_res _res;
> > > >  
> > > >  	hyp_spin_lock(&host_buffers.lock);
> > > >  	if (!host_buffers.rx) {
> > > > @@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > >  
> > > >  	count = res->a2;
> > > >  	if (!count)
> > > > -		goto out_unlock;
> > > > +		goto release_rx;
> > > >  
> > > >  	if (hyp_ffa_version > FFA_VERSION_1_0) {
> > > >  		/* Get the number of partitions deployed in the system */
> > > > -		if (flags & 0x1)
> > > > +		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
> > > >  			goto out_unlock;
> > > >  
> > > >  		partition_sz  = res->a3;
> > > > @@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > >  	copy_sz = partition_sz * count;
> > > >  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > > >  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> > > > -		goto out_unlock;
> > > > +		goto release_rx;
> > > >  	}
> > > >  
> > > >  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> > > > +release_rx:
> > > > +	ffa_rx_release(&_res);
> > 
> > Hi,
> > 
> > > 
> > > I'm a bit confused about this release call here. In the pKVM FF-A proxy
> > > model, the hypervisor is essentially 'transparent', so do we not expect
> > > EL1 to issue that instead?
> > 
> > I think the EL1 should also issue this call irrespective of what the
> > hypervisor is doing. Sudeep can correct me here if I am wrong, but this
> > is my take on this.

> 
> Agreed, but with the code as it is implemented in this patch, I think
> that from the host perspective there is a difference in semantic for
> the release call. W/o pKVM the buffer is essentially 'locked' until
> the host issues the release call. With pKVM, the buffer is effectively
> unlocked immediately upon return from the PARTITION_INFO_GET call
> because the hypervisor happened to have issued the release call
> behind our back. And there is no way the host to know the difference.

I understand your point that you are trying to make the hypervisor
transparent, but it is not behaving in this way. One example is that we still
enforce a limit on the size of the ffa_descr_buffer for reclaiming memory.
Letting this aside, I am curios (maybe on another thread) what do we
gain by trying to keep the same behaviour w/o pkvm ?

> 
> I understand that we can argue the hypervisor-issued call is for the
> EL2-TZ buffers while the EL1-issued call is for the EL1-EL2 buffers,
> but that's not quite working that way since pKVM just blindly forwards
> the release calls coming from EL1 w/o implementing the expected
> semantic.
>

I think blindly-forwarding the release call is problematic and we should
prevent this from happening. It is wrong from multipple pov: the host is not
the owner of the hyp_rx buffer and you are asking TZ to release the
hypervisor RX buffer by forwarding it. Do you agree on that ? I think
like this patch should include this.

> > I am looking at this as a way of signaling the availability of the rx
> > buffer across partitions. There are some calls that when invoked, they
> > place the buffer in a 'locked state'.
> > 
> > 
> > > How is EL1 supposed to know that the
> > > hypervisor has already sent the release call?
> > 
> > It doesn't need to know, it issues the call as there is no hypervisor
> > in-between, why would it need to know ?
> 
> As per the comment above, there is a host-visible difference in semantic
> with or without pKVM which IMO is problematic.

If we apply what I suggested earlier we won't have an issue with the
semantic for this call but it would make the code a mess. I don't think
for this particular call keeping semantics really makes a difference.

> 
> For example, if the host issues two PARTITION_INFO_GET calls back to
> back w/o a release call in between, IIUC the expectation from the
> FF-A spec is for the second one to fail. With this patch applied, the
> second call would succeed thanks to the implicit release-call issued by
> pKVM. But it would fail as it is supposed to do w/o pKVM.
> 
> I'm not entirely sure if that's gonna cause real-world problem, but it
> does feel unecessary at best. Are we trying to fix an EL1 bug in the
> hypervisor here?
>

This was most likely observed from an issue from the EL1 driver (by not
calling release explicitly), it was reported by Andrei Homescu
<ahomescu@google.com>. it appears that we also have to do something
in the hyp about it and we agreed with Will and Sudeep in the previous version of
the patch:
https://lore.kernel.org/all/20250313121559.GB7356@willie-the-truck/

> > > And isn't EL1 going to be
> > > confused if the content of the buffer is overridden before is has issued
> > > the release call itself?
> > 
> > The hypervisor should prevent changes to the buffer mapped between the
> > host and itself until the release_rx call is issued from the host.
> > If another call that wants to make use of the rx buffer sneaks in, we
> > would have to revoke it with BUSY until rx_release is sent.
> 
> Right, exactly, but that's not implemented at the moment. IMO it is much
> simpler to rely on the host to issue the release call and just not do it
> from the PARTITION_INFO_GET path in pKVM. And if we're scared about a
> release call racing with PARTITION_INFO_GET at pKVM level, all we should
> need to do is forward the release call with the host_buffers.lock held I
> think. Wdyt?
>


> Thanks,
> Quentin
