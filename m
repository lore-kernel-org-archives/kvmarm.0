Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776D49658
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628903; cv=none; b=KV1v0cGSoTsUyzOUDkXclytMVzOJfHGB1SO1Z8MbhU4mEbgxTUNFZKykhjhkVctN1fB5+lxGs2jR2q/MJEL6/StPCHaHY++2QeeorGVqLfTX+Vq5LWk5IL7x0VTY1sRw5f8ckIsSwo9eYjt+rl0WaaSOPNevb0eVXTk5zTEkFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628903; c=relaxed/simple;
	bh=eggCc2iIcNGUqxlTvkV0QVMXd9vYfqCFOgNyFcQOOTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HNqzSR6yFmApH9Icfvhzba/WjEc0BvACgeaFOzzl2U2PruvzGrIDbIdPo/w+uBx+2gWJdS9dXqEReU1qveV4sUJodN1lCPXTfr+s/duUqLkjSCgU31T+AOhyQYSuzjU9ciRmW16xSqa3+oIFn3P20waORkgZPHX2Hnw/YbTzPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xkA/oHii; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xkA/oHii"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb5ab2f274so10173929a91.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 13:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628901; x=1723233701; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xQLoSNAIlbI381p0LRgfP/Yiv8RuXN9KeorgYSd+JBM=;
        b=xkA/oHiitSUPav+4QDcov1b1/TqvoyNv5kNGmuUGt0ojmsRJNq/S9GYqCxMeU1Yzbb
         nF/7tGnj88HyULqqLoD+O7MN8zCuTrIDPQ1oJeBqHEyzRl4Z/AsXikr94ZivkyWLL1Xy
         Ds6ta2VYcdqXKJRBeYmCHGbOm7LrvKzkkghl6qR7NOitUqdpOomXg//EnZRkS+vMlXGO
         PjCpKnILt/2zIczIjwXcaxOIRV4Z8qM/lyLzufDxJLXMoYqLSVbXPGdm2KxuLqmpSpPw
         ek4iIH5JOXajlcsu8XF3kxmOv24a+ipf8/QYuZwq3HWugEnguZEkiNoguOJ0+7D+DjwH
         BYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628901; x=1723233701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xQLoSNAIlbI381p0LRgfP/Yiv8RuXN9KeorgYSd+JBM=;
        b=n+HISnUGPgSAMEQJu237rbDHUx8ep64sxiCEDCegBLkUNKqHydaErOob+1Q1y3Ou7Z
         ixjES6lsQcgvhJFFC+f/BQAN5Gghc2hc8BWsHR/kEBqknQDJ7R63raGmD5wxDXhhmnT2
         deS8itTGQuPSWkYHtKQhtmAjuwFSbxXCsDErV0hbGM5r265YlxXSfXiJH1mGRJFc6GlY
         Dxzq5HB3aYd78iLrq2U6Rqz0e8nDqOfnCtBcdettbAvWoptevqn7L+cfljOx33ReHURU
         3mTxLI7fDRfWODLzCKHUqhd9u3FKL0B609apdfpzCZ2SjCAMDH4wZtGDaQvA4eJR1yPk
         qMVg==
X-Forwarded-Encrypted: i=1; AJvYcCVYQZ3VqUf4D451Au8cnUWHa52WEwoXy1E73ut7qo06Qv/Sdn6mLrgrGHrcU1PSB4B5CAgwEET2jROiAk1xEZdG36QoOsO9
X-Gm-Message-State: AOJu0YwboZGuhfYkke/uKtZ2aJhciF+707ejt6PEYipyeOWaTWVAbU8Z
	0meyHV/UgCphRj4qQ9PttWRcyZaohfl2fUPbS7ZbMVfsdRfcyMGUN4PULUUgJZTxMUpXFnUM6LT
	wMw==
X-Google-Smtp-Source: AGHT+IFId3HHn5L5fWCDKxPTuecTBLeAk2p3kpSjqAki6o3dAad+BGMQ+YjK6m4jW2ZqIb6OkUGH+CX4xls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ee94:b0:2c8:9052:58bb with SMTP id
 98e67ed59e1d1-2cff93d2bfbmr119920a91.2.1722628901308; Fri, 02 Aug 2024
 13:01:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:01:35 -0700
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802200136.329973-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Return '0' directly when there's no task to yield to
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"

Do "return 0" instead of initializing and returning a local variable in
kvm_vcpu_yield_to(), e.g. so that it's more obvious what the function
returns if there is no task.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..91048a7ad3be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3932,7 +3932,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
 	struct task_struct *task = NULL;
-	int ret = 0;
+	int ret;
 
 	rcu_read_lock();
 	pid = rcu_dereference(target->pid);
@@ -3940,7 +3940,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 		task = get_pid_task(pid, PIDTYPE_PID);
 	rcu_read_unlock();
 	if (!task)
-		return ret;
+		return 0;
 	ret = yield_to(task, 1);
 	put_task_struct(task);
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog

