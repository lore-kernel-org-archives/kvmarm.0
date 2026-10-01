Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E93B95E0;
	Thu,  1 Oct 2026 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838569; cv=none; b=KNxQNmtgcOGSZRgy8vK/oI6+qkDHo32fB4pBefNDRtaq8iyiYwzX7+9kTq948NfvLEpAJhHIxggkCWls2tvcb3x66pDpRamcT6sZX+8nLFgAgIqeHp/6zrZUE+/j8GngfuQZcxPwg5/SrGaiNjfbrYupePuxIdnXQI+dTb5qHyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838569; c=relaxed/simple;
	bh=qcUv6L8ARdJT3lK/k0JCm9RvmGbRcHITaNoSi4wbxLA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p6VXZg6cjV1Hr6OdpUe//ttzAix8EmwlXDopAeq7Eek86NV7xsO/5SaIhK7yVOM1VoiE0uKktGxB64/PMbbNnKnxHcrFkjMicaqC8Wv2TNkx0HzivgQj3wNe544OSDf8vnGPOegPf05l54F0rrE1dJ0p0k+D/DkupleF7tLWivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVuGX13l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVuGX13l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6001F00898;
	Thu,  1 Oct 2026 07:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790838568;
	bh=9NU2htvl1DJjae4CiPKNFq06tVKMq97HSV7gij/9Ohc=;
	h=Date:From:To:Cc:Subject;
	b=AVuGX13lGxOFnXfsovN9kDWzX1/QIrP1CwOo12N66QAZIz2mPQVi7Emps6B4mQQTU
	 GEbsC+5MQw4si9+hJ+1uucjHZGD4MpYqgaVhdO8H64X8JrF3nuI3BVZy5Aml419hQd
	 9YT4q8FpmUHzC24kcCNBC8FwfVmX6qJIFsP9nUj58fI3XVkoc/Q274RAlBsPfTh9Uc
	 uDGaPNkd99UfPPr1av47dPHHoSbhkD80ZamJL88iPZ3iuIbOx4LDdKeZL7880rAwuM
	 1q1JWaZpFX+eJd5IJmGY1MGfwNk9oIYV4/GCa9ym96aIOIy7YKNcM/2GldWGVQ7diT
	 8JY3WZ+PBgZTQ==
Date: Thu, 1 Oct 2026 00:09:27 -0700
From: Oliver Upton <oupton@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 changes for 7.3, take #3
Message-ID: <ar4HJw9zON0mG2_t@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paolo,

As promised, the patches I was waiting on have baked and we have another
batch of fixes for 7.3. Continuing with the trend, the VGIC is getting
some additional attention, particularly on the handling of a vCPU's AP
list.

Unless there's something truly horrible brewing in the next couple of
weeks, I expect this to be the last fixes pull for 7.3 with Marc taking
over the tree for 7.4.

Please pull.

Thanks,
Oliver

The following changes since commit bc502b86a3cfd89e6740f877c90d06b02635935d:

  KVM: arm64: Use stage-1 leaf size for VM_PFNMAP (2026-09-30 11:03:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-7.3-2

for you to fetch changes up to bc502b86a3cfd89e6740f877c90d06b02635935d:

  KVM: arm64: Use stage-1 leaf size for VM_PFNMAP (2026-09-30 11:03:16 -0700)

----------------------------------------------------------------
KVM/arm64 fixes for 7.3, round #2

 - Take a reference on the last IRQ loaded into an LR to prevent it
   from being freed while running the guest (Marc Zyngier)

 - Ensure that the ITS MOVALL command only affects LPIs that were
   previously affined to the source redistributor (Marc Zyngier)

 - Fix + test for honoring the host's trap configuration when running
   non-protected VMs while KVM is in protected mode (Fuad Tabba)

 - Use the host stage-1 mapping granularity for VM_PFNMAP mappings at
   stage-2 (Mostafa Saleh)

----------------------------------------------------------------
