Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7934252B1
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684117; cv=none; b=pFfRvwaKWInuETk/h8rNVeA0Z6bVoFWGgP9GcyBACbsr+1F965Kb8T67SAi2pxEEvPES7Lg/4JfPH15TdtcJXTY2ZMmrVaiUESm9t2wBEy6MUojFEGLUffi7+B42jdH++aQQNkQPscobQ/pKylM0PoWryY9tWwLF4jsklGXJCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684117; c=relaxed/simple;
	bh=c1Km68m22VthygzsNOKUNrI7kn3Ceh26q/Bds4ZHgtw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QvE7MKk7w8wPkyN5PuY8yJC2gN2hIhRj1oyAJDZCUx8iVN7PZNpkdeMfyLRk1Tqo1Ath0QWfhHSy3JoNP27a/D1mHFe+VFrCOqPtZL+FB3+it4538krbwkKdIF+dlhkqnc35WofRI7hmtmL91/2oIX2PJXFpWGcqYHpyASpV01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J1hUWtQi; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J1hUWtQi"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69841da1946so944231a12.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 04:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783684102; x=1784288902; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2/ihQ717gip1RbIdhAUmFN2VOfCa2WEVlzhqB5HfCVM=;
        b=J1hUWtQipkW3EXV/KCO8vHfiDXodgHlK47jI7VzpcZMH1Wshl314JZ1sLw0w2etLea
         CrpxFyuPfhGy1UtCByvjikFU6kPaQ5GYXcXCadifxkG9PTb7sTUDHbeZNpe83cIZYXd5
         REXsUmkFkZ/Ut5q+CD+5fdQDqR/+0BnkELvbSB3EeHze40PCd85J+FBPdyiri1imDjJn
         OGfcs29z5+UVBl3C5/e+yptWyFAdtf/vUDKRG9zf9r0e7EqWZrzEh7ruN2G9ThPiTWQN
         ZSGyFP9HDxqLT15jx2JY28amsvU0FMvRepg0uEl3tc9ixLmJbNMcMJpbp5hefScKmlmm
         1XTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783684102; x=1784288902;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2/ihQ717gip1RbIdhAUmFN2VOfCa2WEVlzhqB5HfCVM=;
        b=qx5g3gPvK8T/QXThahBuS9AD4pOlV4+zfKY5G/PwNRyh4R5QXE6XGXypOT3TFbSMSa
         SMmFp7oR2156obUZKt0HiwK9Fn+yE9yGD0jUWQ0WpUUY11siCRE0rkk1MlXey+215CgM
         dTWn8Du8FNqAC8rMb0+imp0RtD/DIpeyxLHv2oXU5DI+BmR2tEEnk6nWxj02OO1pABpp
         NsYWak+kRf7lGlvUzZqK97NHuAvPLqpe0szmXr0l0IShyXMeaMEOqiA+hmUfVO5hJzvo
         +uUoLr/hz4C12xl+iGEZIOZPpUNqI3XUlM0oaAIEP6MTP1etlm2G+sghgo8KgqNa1F3L
         1c9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq+Wjf+xH92D0BSECF7PSgAfJAlGkGmFO94VIb3jzseFy5I9V90YLY465OG9r2tgMat1eEl1yw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywtg+jS0H1Y5Jw0iEKXewFIDgB3YEH1ECkU6rSNzpAV51fZTRK8
	LmisE2Rq+X/HSjkRApqtRICRjAYll8WssEkZWEif89gOBzB4mB+f9ldd6qLDHcAnQ8+dUvSzUxC
	crEhJGZWfKYj/x7PAmyzgww==
X-Received: from edt20.prod.google.com ([2002:a05:6402:4554:b0:698:bf64:d684])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:254d:b0:698:3b7c:3b42 with SMTP id 4fb4d7f45d1cf-69ab44c1135mr4839467a12.33.1783684101775;
 Fri, 10 Jul 2026 04:48:21 -0700 (PDT)
Date: Fri, 10 Jul 2026 12:48:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710114819.2689386-1-vdonnefort@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series provides two fixes for the nVHE/pKVM hyp trace remote buffer
allocation.

Changelog:

v2:
  - Added patch: "KVM: arm64: Fix hyp_trace_desc allocation size in
    hyp_trace_load()"
  - Collected Reviewed-by and Tested-by tags from Fuad Tabba for the
    leak fix
  - Do not set bpages_backing_* on __map_hyp() failure (Fuad)

v1: https://lore.kernel.org/all/20260707165029.3410701-1-vdonnefort@google.com/

Vincent Donnefort (2):
  KVM: arm64: Fix potential leak in
    hyp_trace_buffer_alloc_bpages_backing
  KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()

 arch/arm64/kvm/hyp_trace.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0.795.g602f6c329a-goog

