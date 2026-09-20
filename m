Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB88398911
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915017; cv=none; b=t8Ve+1wtcPfvaNLbmz3RWvSQqu/5NkhopDn61grF7sZFyeNc1WrAYn3xDAFLIcopSnKqHJd00s8W3ZJt3YmPCGaNrqKQggI0FlXqvuuJAyolf2p4nTfBGnMrLjAHtp8l1nPJRNpLSgE/qBf70brvXovhqfePIGhCck/2hi+rZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915017; c=relaxed/simple;
	bh=mQ23MGRY/u66yXz3UIgk63neNx6xs6J5UyDzagqLxxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pj9dUGUvNvRWiKIucn1sn6sm/S9/YQKPxyT1qcLdkgl4/IsuWAADdlkEB0oc2nwoEIsxBZroMTAfsF4am8Jp9fUevoKxbxozgU2fmqKXikWKjLgc1TzZGeFuX3AHhmvIS4XXxBImooNx9JTjnJpMGVKz/3LldgNwNrK6ctgwsXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=egiJDzzy; arc=none smtp.client-ip=91.218.175.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="egiJDzzy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mQ23MGRY/u66yXz3UIgk63neNx6xs6J5UyDzagqLxxY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789915008; v=1; x=1790519808;
 b=egiJDzzyfgxhxocOZs5nkHdd4D7IPBYyyDpELnm1f1yq8wA0GqaY/sXosZpl1kT2Kv8XbA2f
 k2Vbwb2VnYKTPy930piYeHuR0wEao9GQBb6ngFtz5el6b7bfe2Kuh5f3wFuRwlyNUgH9fOP7olp
 ZlQp46i5oRF4MvFCGbM6p6x0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f4cc7bfb3ebd34e1;
	Sun, 20 Sep 2026 14:36:48 +0000
X-Mizu-Trace-ID: f4cc7bfb3ebd34e1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso4266e87.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 07:36:48 -0700 (PDT)
X-Gm-Message-State: AFuF++mhsHnAY4gJ0VDJxIjUR9mEuPSM+PISDZAziPOw/mgtmKi3abU+
	AHfvRhzsTsBzR9/hNGtDeHfDn6KtlH4zTLviMGwd5EaVPvC2sxAPTs2sHFRY2o143vzlVRpWLE6
	GNwGn6rmqGc9BwSZX+gVdVzU/kuowFqC0ax8l7XDP
X-Received: by 2002:ac2:5bc5:0:b0:5b8:c922:b54c with SMTP id
 2adb3069b0e04-5b8c931fa92mr37366e87.3.1789915007153; Sun, 20 Sep 2026
 07:36:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260919123150.3283606-1-maz@kernel.org>
In-Reply-To: <20260919123150.3283606-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 20 Sep 2026 15:36:10 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzBWHjnFcYuPtROsEDS4ZFfSNf=VFYoTuG8F+R3Liyi8A@mail.gmail.com>
X-Gm-Features: AcwNN1XWBFVsMxAv3Snaf6xpDNa73UqKxbPSMTBqLL_7dJeswjfUts5eBsRX5bc
Message-ID: <CA+EHjTzBWHjnFcYuPtROsEDS4ZFfSNf=VFYoTuG8F+R3Liyi8A@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: arm64: vgic-v5: Random sparse fixes
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sascha Bischoff <sascha.bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 19 Sep 2026 13:31:46 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> I'm queuing this on top of the existing branch.

For the four as queued in kvmarm/next, fixup included:

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Sparse on vgic-v5-tables.c goes to no warnings, and the vgic_v5
selftest passes on the FVP GICv5 model with a VHE host, before and
after.

The same selftest on an nVHE host oopses in
__vgic_v5_restore_ppi_state() at the first KVM_RUN, with and without
this series. That's the EL1 access to the GICv5 CPU interface that 6/7
of [1] fixes, not new here.

Cheers,
/fuad

[1] https://lore.kernel.org/r/20260915123846.2317931-1-fuad.tabba@linux.dev
