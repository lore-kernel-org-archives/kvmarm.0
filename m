Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9BE3E0C53
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057082; cv=none; b=WZ0k83eXm0ioe8S3ZgMSLvgkydCDigLITYYaTc2t3M3QSxXZ+XgTcnS+xBikKNRQqslYQarFlheJNts1izBb2XNpYfxuhJzm0l6wN8R47+swRdjaStPL4MoRUl7FJTlnh9iT1E9KdJRkgNK5mznFvHbE7xValwa/2p/dLMcK+54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057082; c=relaxed/simple;
	bh=fpxesCo8LSuN66VhAk2gnQnxJf129JDdYilqmDpGag4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uZxEfEtTJUkkjU8OjeOTp3HKKFAOqFdX+YDFy2Yq2IMTF+t7DKdmDJxDZIVXbOvssTDzbB+D5fzoQPjDddHMa77WB2a52bDUZV3eLo7eK16/XQLXSUKUUxczE2MILK3AWFTPoCRRrt2Sz0AQTN99WHe9LKqAXbEdh+qQpnFPOp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rT3TLCMT; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rT3TLCMT"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45e80183514so9768320f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 05:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780057077; x=1780661877; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a4SS+MLrRfo7JjMGlt0hzA5ZHD4Vfkl52EAZVg4EXVU=;
        b=rT3TLCMT/3QVtW1ZarxSIlUt5XC9OT1ginM0G9IhJ/q4aVhNWnaC+cBtCJEir5zotL
         8duLwDDHEb/YO2GbUMco3EYb0m+sNqwyOFz2V4LOuMh2GE2VcbQt2NNMgZ8kw8CcWSnv
         u4QkvWjdr9XY1BRMDoGKAzmtBPHIjYMAFnMwyLVPZ2RH5tAgTpk4PUAaxzWUEIfXBLwd
         EtHgcTK3OjNe/7jJdvZ0uDTMxZ1EfS1i3grTRjgl3waBZwpPfbS+kaOIlTySIqsmuIbZ
         t8A8GtLrIGL8VPbAwQm9pBPlGGnRn+fzvBI+e1m0yfq46Ywyz8AEg2twbNFbM0JeUABj
         P04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780057077; x=1780661877;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a4SS+MLrRfo7JjMGlt0hzA5ZHD4Vfkl52EAZVg4EXVU=;
        b=m4x8sw4I2B0WR5vpYamjhkikruIDfJ20NttORSIC/3XHEQlafQ0gITI52gHuImf4VF
         EGyw1bnPCiGfRix+PfSalKdL0cUxbbdYr39OWYSIzmtLZj6xK0ZhDgf55dA14yRC6Nyz
         A/gFUFTaaJVOh4nKFaFV1rbaLiNmhpXGG2Gx6gY8zZnEBc6HbOBSIBCtokewSAwJfGjW
         iA5gf+x5MeskaAWHpn9uMz+OIHEuePfbywqrsBXRCdqD009U0536exSHcvzAHmys+06M
         k5jd2XN55LEOpcyIxFa8bGeXrlGXKtTURpQO+BETjC4voceFuXtctlor9VSNQMOHaNuS
         wGUQ==
X-Forwarded-Encrypted: i=1; AFNElJ97LB9DPNw5TbWOPZQCUNyjm+1gx1EcbIyAbHPLrbVyH/HACho56+B3ScQw3l3LsSEGfpuaer4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9wSSa33EmuogIRgpalP69r+azzwIt7ltPw8q6RIXfwDlQmCHO
	nJCVN7OQPmGMkKy4BJdokuUZF9DDBBC6aFtSsobjAeazsKVPbFakPlPVEFNYKq1ksyrwkavYPJ+
	IwQ==
X-Received: from wroz13.prod.google.com ([2002:adf:f1cd:0:b0:43d:732c:5800])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:468d:b0:45e:ed7e:f8fc
 with SMTP id ffacd0b85a97d-45ef142a676mr3373752f8f.12.1780057077301; Fri, 29
 May 2026 05:17:57 -0700 (PDT)
Date: Fri, 29 May 2026 13:17:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529121755.2923500-1-tabba@google.com>
Subject: [PATCH v2 0/3] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks,

The first two started as bugs I found testing Sashiko locally with
fixes to review-prompts. The third grew out of the v1 discussion.

share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c maintain
a host-side RB-tree mirroring the set of pages shared with EL2. The
hypercalls they wrap can fail (page-state mismatch, EL2 refcount still
held), and neither the per-pfn helpers nor the multi-page wrappers
cleaned up correctly on failure:

- share_pfn_hyp() left its tracking node in the tree on failure,
  leaking the allocation and presenting a phantom share to a later
  unshare (patch 1).

- unshare_pfn_hyp() erased its tracking node before the hypercall, so
  on failure the host lost its record while EL2 still owned the share
  (patch 2).

- kvm_share_hyp() returned on the first per-page failure, stranding the
  pages already shared by that call: the caller treats the whole range
  as failed and never unshares them (patch 3).

As Vincent and Marc noted on v1, none of this compromises isolation. A
page that cannot be unshared is simply leaked: it stays shared with the
hypervisor and is no longer reusable for pKVM. So kvm_share_hyp() now
rolls back on failure, and the unshare WARN_ON()s are left non-fatal
and documented rather than promoted to BUG_ON(). The system keeps
running, and only later pKVM reuse of a leaked page would fail. We do
not expect any of these paths to trigger in practice.

Severity is low and this can wait for 7.2. Patch 3 builds on patch 2,
otherwise they are independent.

Changes since v1:
 - New patch 3: roll back partial shares in kvm_share_hyp(); document
   the deliberate leak-on-WARN in kvm_unshare_hyp() (Vincent, Marc).
 - Patches 1 and 2 functionally unchanged (patch 2 gains the call-site
   comment).
 - v1: https://lore.kernel.org/all/20260529074341.2271950-1-tabba@google.com/

Cheers,
/fuad

Fuad Tabba (3):
  KVM: arm64: Free hyp-share tracking node when share hypercall fails
  KVM: arm64: Avoid host/hyp share desync on unshare hypercall failure
  KVM: arm64: Roll back partial shares on kvm_share_hyp() failure

 arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

-- 
2.54.0.929.g9b7fa37559-goog

