Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC9249EB
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 20:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628902; cv=none; b=XuXy5gJycaIV1kD5dL4eFmhRxdPu+riBJG2rrFFpTZrTWcLdEASGXFaO5QjloK5E7nox99wr8AUcbmg5E4Hgj9E1PKB6m9qYuy2QTlx8S5m2+IQeOIIu/kOj5LIJW3Kz+4Yl0+1u2xrjHfhKy2VaJOsdjvfJTvEuie8Ga550Otw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628902; c=relaxed/simple;
	bh=g97mdCp4arIit1LwToTZXmazYyh6y72jv1vjtPPZOik=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SrLg3HG4Z7RrVS1q4nZN2lzP1jLMuqnmJaGhg5Z7/5cCt0eyI1gkoe4ECqyhXlTMX5H21tYKNnnZdzDPhdj1sxx1SaLb8R/CwFadhM4ME9N+rjnVcOvLOLUtSW5/th5GKACiNGZxvYdRRMBUmJfwIqJCenKR2goejLG6YfBph8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ElcHzFSy; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ElcHzFSy"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso13548113276.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 13:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628900; x=1723233700; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ykPdpt4afpZ3jpFw7YSK1YDxe3tZo0sfBfoXskTzJEA=;
        b=ElcHzFSyzXldlYnKJxk9ijSYNG4irwZByj/Y6NNBnW3kT0qGUWX9zpaiB9RnEArpD7
         7RQZA/cvjJxRLMhYIuZZ3XiWuGaOcszLG0pW4aVohgSK76y9tv7w8HDHQBMgCtR5m6Kz
         nmWybQdQWMTlQw0bO18U6GQThL8lU+ZAD5lgRhbTWXe8jOqDLNLzaBUQYcOR8YxqzELz
         LElY+VJBqZj5870hgsZMamx9ijvPh0hyApU466JFNNB6RGtsHYLQIgHxAiZpjOUBZMm+
         ac903roYahC1SfcDvhSqpoS0wd0WiybW0KsErKYPnM5SQTo2rEHvFE7vgKinf6w0xvPh
         PJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628900; x=1723233700;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykPdpt4afpZ3jpFw7YSK1YDxe3tZo0sfBfoXskTzJEA=;
        b=odMhVNvAW08vr0HMlG7pIiTOMaBeQjfayUJjn6pBaZUPtosxqiNqeYdI4RvuCi/NVZ
         YJ/BBj028c/Eq02C1jYnfV2n+bQnKtlCCMAa0/QqhIzpN2BW7/TqnVFjyvCM3wR71gzY
         lTvisex4e1VTlV+HiXVpmo/xc9zcd/RyhExpDisnDhVKq+uM59HU+3SvdkBExDB/KNfs
         1LSknauBUqif2rBHrk/Kz0d0WysNh4QsReAiLxeb/yvSbwygXk0kF7CkBAeKV3B3Wn4R
         pXnnVn9q1TeTOAKEYnMBnl1xmsUChlZJwwzRsPwvnSQIip4QcG9X9ij0H9blbo1yPJ17
         Lwhw==
X-Forwarded-Encrypted: i=1; AJvYcCUNV3/HlamZsys1++w8iRrx9SkegSnoxPvCfW9HxjzYnsDS8w/2I2smcM86fnPiDkZyM7TLCwKyeSYHxhK/VoMKVx9UUDRO
X-Gm-Message-State: AOJu0YyFSmPgOuwD+O+j09eUu5PHOaZhTz33XCUS3IK5hp8EQ2C0B57/
	nh/yGnuxQmA4mwwtTU4U/RLYRwjL6I65qeVWZ2AnyylwAgaJzVxpxbD5yemD8Fll1qETd3/okJw
	HxQ==
X-Google-Smtp-Source: AGHT+IFmEjE0twSlJTivyvNHNugTEVFQQZk8biWQMQbekPfidDKP6UgVbg8OwPEN3Johcfln+K3aJZ+eKcI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8601:0:b0:e05:f1ad:a139 with SMTP id
 3f1490d57ef6-e0bde435653mr6717276.11.1722628899703; Fri, 02 Aug 2024 13:01:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:01:34 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802200136.329973-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Protect vCPU's PID with a rwlock
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"

Protect vcpu->pid with a rwlock instead of RCU, so that running a vCPU
with a different task doesn't require a full RCU synchronization, which
can introduce a non-trivial amount of jitter, especially on large systems.

I've had this mini-series sitting around for ~2 years, pretty much as-is.
I could have sworn past me thought there was a flaw in using a rwlock, and
so I never posted it, but for the life of me I can't think of any issues.

Extra eyeballs would be much appreciated.

Sean Christopherson (2):
  KVM: Return '0' directly when there's no task to yield to
  KVM: Protect vCPU's "last run PID" with rwlock, not RCU

 arch/arm64/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h          |  3 ++-
 virt/kvm/kvm_main.c               | 36 +++++++++++++++++--------------
 3 files changed, 23 insertions(+), 18 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog

