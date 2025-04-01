Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C11202961
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743508847; cv=none; b=b8DQSR4lvYThCq2LTafWd8vAnpT3gDTm6uYPiXVSl0nYQuvAvFRC5sxr5DzCJMVQlyaZ5f77Y798UFCRTzaAw7IhdzEhG5mQfDl9w71LQZetncafqlnZcONaNhQqghWNCNgGhEnQRQ9rEdoVyuN0jfP5x9avKZEzIzLESYhHFcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743508847; c=relaxed/simple;
	bh=Nk+zfdBGf768n9c2CJBQgeGoqdEJCGG2WcBiwDAIxO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgzNyQm/4jogrNtuOgz2yYuu3kPIclshMk5lhg4aVr17CmbGYEExzeURSwTJQj/VMqZsQMYuXrVKPRHriPzHz198I22Q6GbTLlU50Zz+NQ9gC3QEihukvGNnXrSsjf0w4PHn/fJR9o++RXBUWRpYhgOPuSMUaiXHb5Z5BVIUaqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGc0Iizn; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGc0Iizn"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so967660466b.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 05:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743508844; x=1744113644; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KzsCJ2IGyxdKIiqjLYd73ZTqGRLCVNxlPOpt9uwfCs8=;
        b=MGc0Iizn/4lDhmGPKhG+xM+T1vI7VJAR3ey6ZryAwtFLRV+18B3ha340he76B2MfWk
         Dh7txZ5iveNayDxDClGi1xposkK0eq6BPO0rThYZDcUmZrK+GjBVlukpaurNLwLBnXy5
         D3H1NOsgSkBBNE7BQqDBZBmLkoRLuHr43DPRkh6+XS/pYqg09P8oCtNN/NdiKFJM/acB
         pGsRlIAsA2lNVBMLMi+fY0LJyTpQs6ejdW2b97LOjDQybF5+a64eJmYZs55DRpoW1RMP
         IipHTtNci9au0aKX2+KFA0PTq+o8du40AWyH+kKSvth7JOGaVpRNd4KSkht+jDP1uPn7
         C/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743508844; x=1744113644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KzsCJ2IGyxdKIiqjLYd73ZTqGRLCVNxlPOpt9uwfCs8=;
        b=UjNqPZMsMkTMEaFtqCpYkKSviOyM/1l7GX6rKtFqcXcAdLp5Yzzk1wOiYl1QtJ1bi+
         cJwuAwVN86dAa7gHJTFffm0EPYRG35qcExwLN4yYr5BXZLEw7k3Fx2/c//KXgFq+w8Us
         rRvACey3TVz35poG2Erh4Bgpqrj5Oza+dcVlR/GyJl+H2bj9QrudPU8Ml7Qyxt6R600Y
         fgNul8OLzq3aVVsTxykUhuP69JqkeTAGfwNhB6rpD/f02SqPLtzXd0Mob2snWG2ygLmn
         5vVRZOkIxjZwP/43Qkwl9Q9eWnJeUw+SrAKNv9YFvdMCxjktIWYOouuQOCIUmNOL5KrJ
         q8/A==
X-Forwarded-Encrypted: i=1; AJvYcCWoqt7lcANSTGgerVTkG5TOqnFp0+QmL/xUYDm4g5fB9QK3sz8R/UIuKFjwGBS+sbW8TQkksJw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDBIaQlzX6g/9rf/hQq/o3x8ecULuVuBBrSehQR5jXuBlNvf9h
	s9hHaeNOJcCReXfT8pQgZHH9Mv/oFxoMqKhhtlvAAnPBLcCKB4Th5Ixiho43jA==
X-Gm-Gg: ASbGnctxofoq0ikqAn0aU4te/HGSIbxR+5ljWw5+yzRj8yo8dCd6uy7qNvJ0BN6yh5X
	STnMN76d7Fg7O1GJmyTsUu4ef5pznq6rtFYWtYWiFPmtxqb5QV/R0kHIv2hFyZKrfcBgA4589ru
	iAgRo6LBvHQnV2AxRjq4Dv6Tzmkl8jzL34jetb/9bxZa/wEgvC3G8gcBGF4TSKtFoQrGR+ZKbPK
	Lax8TdGnzhCfe6jkBsOyW01o1zShEYkq9ikmxfMRgr22h2sFZtb4+W027L8q2FLsiPmcZrTea2m
	Jhk5UQDOdEgjL7iikRpSUhdKQ56LQ2D3SyNht7eXZ0mO6sAFQpky+2Ld4Wi8O8VE1ISxDvXoSCt
	YmtA=
X-Google-Smtp-Source: AGHT+IGj2qpmOUX6m4RgNmmkTS5ejyDLKLtEkj+uK3UkSRN7gepeVjiCJ8Ox8oxGWF/rBKjo18fJBw==
X-Received: by 2002:a17:907:d1a:b0:ac3:8aa0:9d70 with SMTP id a640c23a62f3a-ac782e939femr247151766b.51.1743508843143;
        Tue, 01 Apr 2025 05:00:43 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922baeasm753744866b.33.2025.04.01.05.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 05:00:42 -0700 (PDT)
Date: Tue, 1 Apr 2025 12:00:38 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <Z-vVZt6RTNX90uEw@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
 <Z-Qv4b0vgVql2yOb@google.com>
 <Z-UcW32Hk6f_cuxc@google.com>
 <Z-aKgXVjp4nNJcLd@google.com>
 <Z-avzxyyOiaIk3-C@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-avzxyyOiaIk3-C@google.com>

On Friday 28 Mar 2025 at 14:18:55 (+0000), Sebastian Ene wrote:
> On Fri, Mar 28, 2025 at 11:39:45AM +0000, Quentin Perret wrote:
> > On Thursday 27 Mar 2025 at 09:37:31 (+0000), Sebastian Ene wrote:
> > > On Wed, Mar 26, 2025 at 04:48:33PM +0000, Quentin Perret wrote:
> > > > On Wednesday 26 Mar 2025 at 11:39:01 (+0000), Sebastian Ene wrote:
> > > > > Introduce the release FF-A call to notify Trustzone that the hypervisor
> > > > > has finished copying the data from the buffer shared with Trustzone to
> > > > > the non-secure partition.
> > > > >
> > > > > Reported-by: Andrei Homescu <ahomescu@google.com>
> > > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
> > > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > index 6df6131f1107..ac898ea6274a 100644
> > > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > @@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > > >  	DECLARE_REG(u32, uuid3, ctxt, 4);
> > > > >  	DECLARE_REG(u32, flags, ctxt, 5);
> > > > >  	u32 count, partition_sz, copy_sz;
> > > > > +	struct arm_smccc_res _res;
> > > > >  
> > > > >  	hyp_spin_lock(&host_buffers.lock);
> > > > >  	if (!host_buffers.rx) {
> > > > > @@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > > >  
> > > > >  	count = res->a2;
> > > > >  	if (!count)
> > > > > -		goto out_unlock;
> > > > > +		goto release_rx;
> > > > >  
> > > > >  	if (hyp_ffa_version > FFA_VERSION_1_0) {
> > > > >  		/* Get the number of partitions deployed in the system */
> > > > > -		if (flags & 0x1)
> > > > > +		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
> > > > >  			goto out_unlock;
> > > > >  
> > > > >  		partition_sz  = res->a3;
> > > > > @@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
> > > > >  	copy_sz = partition_sz * count;
> > > > >  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > > > >  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> > > > > -		goto out_unlock;
> > > > > +		goto release_rx;
> > > > >  	}
> > > > >  
> > > > >  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> > > > > +release_rx:
> > > > > +	ffa_rx_release(&_res);
> > > 
> > > Hi,
> > > 
> > > > 
> > > > I'm a bit confused about this release call here. In the pKVM FF-A proxy
> > > > model, the hypervisor is essentially 'transparent', so do we not expect
> > > > EL1 to issue that instead?
> > > 
> > > I think the EL1 should also issue this call irrespective of what the
> > > hypervisor is doing. Sudeep can correct me here if I am wrong, but this
> > > is my take on this.
> 
> > 
> > Agreed, but with the code as it is implemented in this patch, I think
> > that from the host perspective there is a difference in semantic for
> > the release call. W/o pKVM the buffer is essentially 'locked' until
> > the host issues the release call. With pKVM, the buffer is effectively
> > unlocked immediately upon return from the PARTITION_INFO_GET call
> > because the hypervisor happened to have issued the release call
> > behind our back. And there is no way the host to know the difference.
> 
> I understand your point that you are trying to make the hypervisor
> transparent, but it is not behaving in this way. One example is that we still
> enforce a limit on the size of the ffa_descr_buffer for reclaiming memory.
> Letting this aside, I am curios (maybe on another thread) what do we
> gain by trying to keep the same behaviour w/o pkvm ?

The idea was to avoid as much as possible needing driver-side changes
depending on pKVM being present or not, to allow code re-use as much as
possible.

> > 
> > I understand that we can argue the hypervisor-issued call is for the
> > EL2-TZ buffers while the EL1-issued call is for the EL1-EL2 buffers,
> > but that's not quite working that way since pKVM just blindly forwards
> > the release calls coming from EL1 w/o implementing the expected
> > semantic.
> >
> 
> I think blindly-forwarding the release call is problematic and we should
> prevent this from happening. It is wrong from multipple pov: the host is not
> the owner of the hyp_rx buffer and you are asking TZ to release the
> hypervisor RX buffer by forwarding it. Do you agree on that ? I think
> like this patch should include this.
> 
> > > I am looking at this as a way of signaling the availability of the rx
> > > buffer across partitions. There are some calls that when invoked, they
> > > place the buffer in a 'locked state'.
> > > 
> > > 
> > > > How is EL1 supposed to know that the
> > > > hypervisor has already sent the release call?
> > > 
> > > It doesn't need to know, it issues the call as there is no hypervisor
> > > in-between, why would it need to know ?
> > 
> > As per the comment above, there is a host-visible difference in semantic
> > with or without pKVM which IMO is problematic.
> 
> If we apply what I suggested earlier we won't have an issue with the
> semantic for this call but it would make the code a mess. I don't think
> for this particular call keeping semantics really makes a difference.

Right, if we implemented the release call properly in pKVM I'd be happy
with this patch, but I just don't think we should only do one half. We
either do it properly in pKVM or leave it with to the host -- the latter
feels simpler to me, but no strong opinions.

> 
> > 
> > For example, if the host issues two PARTITION_INFO_GET calls back to
> > back w/o a release call in between, IIUC the expectation from the
> > FF-A spec is for the second one to fail. With this patch applied, the
> > second call would succeed thanks to the implicit release-call issued by
> > pKVM. But it would fail as it is supposed to do w/o pKVM.
> > 
> > I'm not entirely sure if that's gonna cause real-world problem, but it
> > does feel unecessary at best. Are we trying to fix an EL1 bug in the
> > hypervisor here?
> >
> 
> This was most likely observed from an issue from the EL1 driver (by not
> calling release explicitly), it was reported by Andrei Homescu
> <ahomescu@google.com>. it appears that we also have to do something
> in the hyp about it and we agreed with Will and Sudeep in the previous version of
> the patch:
> https://lore.kernel.org/all/20250313121559.GB7356@willie-the-truck/

Thanks for the context. I'm still not convinced issueing the release
call in that way is fully correct, but happy to be corrected on my
understanding of the spec.

Thanks,
Quentin

> > > > And isn't EL1 going to be
> > > > confused if the content of the buffer is overridden before is has issued
> > > > the release call itself?
> > > 
> > > The hypervisor should prevent changes to the buffer mapped between the
> > > host and itself until the release_rx call is issued from the host.
> > > If another call that wants to make use of the rx buffer sneaks in, we
> > > would have to revoke it with BUSY until rx_release is sent.
> > 
> > Right, exactly, but that's not implemented at the moment. IMO it is much
> > simpler to rely on the host to issue the release call and just not do it
> > from the PARTITION_INFO_GET path in pKVM. And if we're scared about a
> > release call racing with PARTITION_INFO_GET at pKVM level, all we should
> > need to do is forward the release call with the host_buffers.lock held I
> > think. Wdyt?
> >
> 
> 
> > Thanks,
> > Quentin
