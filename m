Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688501F12F2;
	Thu, 13 Mar 2025 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741867472; cv=none; b=EV3o9sDkqw1PeCZ348Cn9wL+/RFL2/wXZBPoSvXeTvTVsTR0PDocjVRA30iWF3qZuMDFA+WLYnooRgDBZF4aLYXBpYagrKiJ+SlvITjhfWKj4XpW2GW3s++bapT/LgIur8Sx3+iryPk5M9dosZQhYOpZivfLx849dFKpuYWydu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741867472; c=relaxed/simple;
	bh=8xSatFqW6rNQRg2ui1Hv5/Ccru9q7nKvNSRlZwWl5L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6FidkqMNKIaC2336buTEw3XAegKbgC4kcH0E1q2EENyq4FtoPG9Rx/9md6NgqmU5EFgJyAx8TmWZnZWggf/VAf/jWWY0/Ymnm4kB05DYuZ62LSq4hHuw7U6fMb+oDEuJAp4OnwC+XXGDgtAay64ECULnlddolaTyi39nG3+UKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laX+XLbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laX+XLbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63084C4CEDD;
	Thu, 13 Mar 2025 12:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741867470;
	bh=8xSatFqW6rNQRg2ui1Hv5/Ccru9q7nKvNSRlZwWl5L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=laX+XLblooglk5nBQ2OLuWGhtqj6qrkClKYXRqLBhPW0lc/doJ6OVCdrBiPC/mTg3
	 ypllpZEyEwH1ZbJzgDmhfoLX3y2MLs0YZrWb+QyiKz5xxK1jEYFyTd9UKk1REzAwA8
	 R/d1CxybPiNxrCUnCouHJpBqv5ItV/PRF6qtbE+mOgG6K0BSG6kPtEvtqd4+TQOIOi
	 qFC9lieHIU8DcOyk/fWQduHA0ZcfKs3vux9ZjxFIecAZ+oC7p/RQoDadjYIfTJVoWc
	 AilbK0CyDNeNEKUsz4aHgixCNVndewaZqO/0AKyFWEkNbO3ETwosS1fdTQFuEZN3XQ
	 pj8pCpmOSW1Ew==
Date: Thu, 13 Mar 2025 12:04:25 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <20250313120424.GA7356@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
 <20250303234259.GA30749@willie-the-truck>
 <Z8ZPBZF7J-qKdb_i@google.com>
 <20250304015633.GA30882@willie-the-truck>
 <Z8c6enoolJe7Zeqk@google.com>
 <20250305003808.GA31667@willie-the-truck>
 <Z8iZkQHknZfY7mpn@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8iZkQHknZfY7mpn@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Mar 05, 2025 at 06:36:01PM +0000, Sebastian Ene wrote:
> On Wed, Mar 05, 2025 at 12:38:08AM +0000, Will Deacon wrote:
> > On Tue, Mar 04, 2025 at 05:38:02PM +0000, Sebastian Ene wrote:
> > > On Tue, Mar 04, 2025 at 01:56:35AM +0000, Will Deacon wrote:
> > > >   | [...] negotiation of the version must happen before an invocation of
> > > >   | any other FF-A ABI
> > > > 
> > > 
> > > We do that, as the hypervisor negotiates its own version in
> > > hyp_ffa_init.
> > 
> > hyp_ffa_init() only issues FFA_VERSION afaict, which is the one call
> > that you're allowed to make during negotiation. So the existing code is
> > fine.
> > 
> > > I think the host shouldn't be allowed to overwrite the
> > > hyp_ffa_version obtained from _init, this feels wrong as you
> > > can have a driver that forcefully downgrades the hypervisor to an old
> > > version.
> > 
> > I think that's also fine. The FFA code in the hypervisor exists solely
> > to proxy requests from the host; it's not used for anything else and so,
> > from the host's persective, FFA should behave identically to the case in
> > which the proxy is not present (e.g. if we were just using VHE). That
> > means that we're doing the right thing by deferring to the host for
> > version negotation.
> > 
> > Are you saying there's a bug in the current code if the host negotiates
> > the downgrade?
> 
> It is an issue *only* for doing guest-ffa (which isn't posted here yet).
> If we allow the host to dictate the version & there is an issue with TZ
> FF-A dispatcher in that version => the guests will be affected by this
> as well.

When we get to guests doing FF-A, I still think the host should be
responsible for the version negotiation and guests should just be given
whatever has been negotiated. We could extend the hypervisor to marshall
between different versions, but I'd rather do that only if we actually
need it.

> > > We need to do three things, Sudeep & Will please correct me if I am
> > > wrong, but this is how I see it:
> > > 
> > > - the hypervisor should act as a separate entity (it has a different ID and
> > > in the current implementation we don't do a distinction between host/hyp) and
> > > it should be able to lock its own version from init.
> > 
> > I strongly disagree with that. The hypervisor isn't using FFA for
> > anything other than proxying the host and so we don't need to negotiate
> > a separate version.
> > 
> > What would we gain by doing this? Is there a bug with what we're doing
> > at the moment?
> 
> I think we need to make a distinction between the host and the
> hypervisor when we are adding support for guest-ffa. We currently have
> the same id (== 0) for both of them.

Right, and we currently don't support guest-ffa, so no problem :)

> > > - keep a separate version negotiated for the host
> > > - trap FFA_ID_GET from the host and return ID=1 because
> > >   currently we forward the call to the TZ and it returns the same ID
> > >   as the (hypervisor == 0).
> > 
> > Why is this beneficial? It just looks like complexity at EL2 for no gain
> > to me, but maybe I'm missing something.
> >
> 
> Because the host can impersonate the hypervisor using ff-a direct calls atm.
> and we are in a position to restrict the host from playing nasty games
> with TZ.

Can you give a specific example of why impersonating a direct call is a
problem? I agree that it sounds bad, but the hypervisor is still in the
middle and so it can check what the call is requesting.

Will
