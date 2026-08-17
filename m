Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E93F076F
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786990930; cv=none; b=JlTGmIyjbhguJiu4hGuM2UHB9f2SeXGjT06mFuTUDLe64kuMOjHqqvGqk+/u/AJpr9CAtfKc9yQ22zXprhzK/q57iFy80AQWqWQIiozoVgaR7h/GzvjfJAdzOlmMSV6q3gGtjtlu5GrEHgZU8DNgdnLHjD0oV1BzoV01cJmSEKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786990930; c=relaxed/simple;
	bh=/A6KjObyhq7cVhHMbT2KKH6Oo7ujhT7xd/MtfUsrEqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OW3qT6Ic/N8bzc85OxyvRdHUqgYAiW2kNqk3RSEp7f3grvPIbA2HMbWKY7ndpZx+KLkzmDv3MaSAgUnHM3illI6eqno5k99BWq+todKeA/fEteyCE3CIUdN6ExmvyUGwJI1UZ4ggz6K4lAvIkcMjz/SRusI2I2il0x+2fE+ZmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ttd0mZ2T; arc=none smtp.client-ip=95.215.58.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ttd0mZ2T"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/A6KjObyhq7cVhHMbT2KKH6Oo7ujhT7xd/MtfUsrEqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786990925; v=1; x=1787595725;
 b=ttd0mZ2T6DASa4pEMcbkMpGqgyVSS/esGePw5KOH8nkQYzuar+IvfENSm7UtirVwZq5M8Xt/
 6x91StNySpBjrgSLmIPlK3tbNE5X2DBxNecqG12w41HRSYszVJdSluqXkHT5Z21pcN3QwI0odWi
 bmar4/OJ4TQlbo7ocJljenUw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f51.google.com (209.85.167.51)
	by smtp.migadu.com with ESMTPS id 0910b628b7a14f0e;
	Mon, 17 Aug 2026 18:22:05 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so919e87.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 11:22:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqMdSyhd5Y18KHBSg2CbRV2qx1LQnQx2AwTv+3BuiGvlP4DkCsm9aM+Xz1m9XYEm3fabwk1hoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYnIGyrV5srrPNcbATah03fTDfgV4e1D+Ne4Fj2d50Jbhhj8Xv
	ZUX4Nv75Ftt1RLlvIz3DvJNBKN3vM5DzbPTD4q5OKOLGTE912kCVGJ9Wo6UPhihJeMfFERW/3Xr
	njXsVUesJL4Iozv0beoFhkZUn1UCbhBVrMnq2Jqo/
X-Received: by 2002:a05:6512:3b82:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b471fc851emr21997e87.6.1786990920611; Mon, 17 Aug 2026
 11:22:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-4-fuad.tabba@linux.dev> <87ecg9owwa.wl-maz@kernel.org>
In-Reply-To: <87ecg9owwa.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 19:21:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy90YP8dzUy724VQ7vzVusr+mGocFxyHoQZ2c4OJnpBcQ@mail.gmail.com>
X-Gm-Features: AcwNN1VsZZX6k3eIXS5T0yPwB2Cj45iz_ikQ2tsaPPV3wj_Pap_RqK51TbezACk
Message-ID: <CA+EHjTy90YP8dzUy724VQ7vzVusr+mGocFxyHoQZ2c4OJnpBcQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic-its: Don't save collections the
 table cannot hold
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

Sorry for the slow reply, I was away.

On Sat, 8 Aug 2026 at 09:09, Marc Zyngier <maz@kernel.org> wrote:
...
> > A guest that disables the ITS and rewrites GITS_BASER with fewer pages,
> > VALID still set, keeps every collection it mapped against the larger
> > table: KVM stores the new BASER unconditionally and frees the list only
> > when VALID is cleared.
>
> But isn't that the *real* problem? Shouldn't we instead nuke the
> collections entirely and go through a reload sequence?

Agreed, that is the problem. The fix belongs in vgic_mmio_write_its_baser().

Should it drop everything, or only the collections that no longer fit?
On a shrink in place the low ICIDs are still in the table. Or is no
realistic guest doing this, so the simpler rule wins? I can do the
unconditional drop if you prefer.


> > Validate each collection against the current table with
> > vgic_its_check_id() and return -EINVAL, as vgic_its_save_device_tables()
> > does for devices. Collection IDs are unique and the collection table is
> > never indirect, so the check also bounds the walk.
>
> I think returning -EINVAL here was a mistake, as it aborts the save
> procedure that userspace should be able to issue reliably, even if
> that means the state is crap. I don't think we should expand that
> behaviour any further.

Fair enough. Either way the check goes with the fix rather than being
expanded: MAPC, MAPTI and the restore path already validate against
the current table.

vgic_its_save_device_tables() is harder: with an indirect table the
guest can invalidate an L1 entry without touching GITS_BASER, so that
check can still fire. Skip the device rather than fail the save?

Cheers,
/fuad
