Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A700A31A56C
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628215; cv=none; b=AF2Gu36yrI3MsA8SeeCwxmVlFN3zSvRe/QdDFXUL9h2Qv1uSZClf9L/b5zZQhujUjC43/H2NYHQWmorot7TV7wjeAm/hf6qh1BTty9yf6FiwJvAak1EfP20RnD2gtzEMAMc0QrLOnpLHK2uJO9G4pWHp75PPgyBZj9WbTsj+A+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628215; c=relaxed/simple;
	bh=FMgH4tjmmPzyeMSdlENmcMAZuZ5jAY2wrE5NYUN4Hvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEGLngJnZCfJSkYpzQtJo1ORzE089AN0DCWbZxE0v0cm0QJOQZbSfyhavEeEZKm5iTBuMy9YdT1aQ6SrEQhJnbKBW34Plns9jGTa8F+6EwQV+KPlK7MJYbkoDGH4D+U5SZLwPFchR+45DB4x/7Ocn3jUK6Lc4inehHcAcRhbW7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fqe6pn6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fqe6pn6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F19FC19425;
	Mon,  5 Jan 2026 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628214;
	bh=FMgH4tjmmPzyeMSdlENmcMAZuZ5jAY2wrE5NYUN4Hvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fqe6pn6Ocahv3hqhHuzUxcGmCjLM1isCKz3KxZSjp9wwvlnJhxkrD+jRFqBFnHK6t
	 3pCqJr/6H+dd3UOSyjGcTat3gebE8uZFWa5ur0yQEtjjyie+dLGSNek15sBlGzEe3O
	 AAU4dpxz3/IEgRi/gr67OGMVX9ogEFmZRmSWuQJ7/OgCKAgr/gtcM3k8yY7RN4AwDe
	 BlFKh4vyWkvaeISHUR0ki/1GU8xQMu+FTwB7fXBelbqplzn6B3IdZiHYMrDWhuun9e
	 jidaSmoyi0bYYCICQED2UEtcuqArZzSUdvWMDTyY7PdcoLoozT2S/dEHhslYj9nOAE
	 D3/3CP/tZmoUA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 08/30] KVM: arm64: Prevent unsupported memslot operations on protected VMs
Date: Mon,  5 Jan 2026 15:49:16 +0000
Message-ID: <20260105154939.11041-9-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected VMs do not support deleting or moving memslots after first
run nor do they support read-only or dirty logging.

Return -EPERM to userspace if such an operation is attempted.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a888840497f9..8f290d9477d3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2419,6 +2419,19 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
+	if (kvm_vm_is_protected(kvm)) {
+		/* Cannot modify memslots once a pVM has run. */
+		if (pkvm_hyp_vm_is_created(kvm) &&
+		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
+			return -EPERM;
+		}
+
+		if (new &&
+		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			return -EPERM;
+		}
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
-- 
2.52.0.351.gbe84eed79e-goog

