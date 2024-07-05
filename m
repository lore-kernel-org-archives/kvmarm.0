Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364EB13665A;
	Fri,  5 Jul 2024 09:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720171921; cv=none; b=YoEI7z4H2ekRu+QTh59yV6+ovgr72qFpQQPyMmE8LIl6wIauQNzTPfS8wHne8qXjDVEIJNudQUi17KcOlFLuexM5jvT+sNgpP3gO9Tf/QB3E6UKqYTAG9KQMYb0Ljt9lvozVM5IeNSPMJQGKQ7dia/qgo1t8BYphhDbh3fTywNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720171921; c=relaxed/simple;
	bh=Hzb9ioOe75iuE8nil3shI39R8UAVrKoKUtFNw7Yvnpk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YOZdBy52/y0WKWuNohvjjcG6Tqx7Uxogpl0QGh9rZYEUivuqf5/g4dwGR+dCnBDMU9/boeLhh4to4CnI1b4Tdxk+koaYSC8Ebut+ZpAvrLd4Q7qJwF086Boh8gGge8f+1wg1obyUEr0ZJJE2G8cwuiFdg3vuHCl+iuAlIqR0JlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiLzy/CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiLzy/CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEC1C116B1;
	Fri,  5 Jul 2024 09:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720171920;
	bh=Hzb9ioOe75iuE8nil3shI39R8UAVrKoKUtFNw7Yvnpk=;
	h=From:To:Cc:Subject:Date:From;
	b=TiLzy/CVDuVmncADPZ3ZXszOGVJQjYV+m7aARw3zOLsU5tL5y0i+R/j3rBqjVbI5V
	 0LTKwKs1XvO6tCHdtz1sysCdvIUhHXrrmvmyEoG5wUdTQ/9f21159ciVpJC8M3pXdi
	 n8QPnQW0id1pUskOaiE/DcETpDpqJUzWv7lMw6BuQR3imGGCkjw4oBmDmyB7IiW6pi
	 mLtqJSQ5jQnYqntl9Fyj5px3GrnA4Pmwxd9vwNjn89bxKEgvgKKWDMhKbOpxAcH3h7
	 wHMETqAwdEJsZoyUv7gtIKNRdOV3RK8JJBnmt9NZ3SyTWc2rrGOfGHa9bkcJWad297
	 LhNjkDLAEl+HQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sPfIM-00A0NK-Gy;
	Fri, 05 Jul 2024 10:31:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Nianyao Tang <tangnianyao@huawei.com>
Subject: [PATCH 0/3] irqchip/gic-v4: Fix VMAPP/VMOVP races
Date: Fri,  5 Jul 2024 10:31:52 +0100
Message-Id: <20240705093155.871070-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, tangnianyao@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In 20240701072305.4129823-1-tangnianyao@huawei.com, Nianyao reports
a number of possible races that can trigger on GICv4 implementations
using the ITSList feature.

These races involve concurrent VMOVP and VMAPP, the former happening
on vcpu load, while the latter is triggered on the first device being
MAPTI'd on a given ITS for this particular guest.

The main issue is that we want to establish the affinity at VMAPP time,
while vcpu_load wants to set the affinity where the vcpu actually runs.
Lock ordering constraints mean that we can't lock the VPE on VMAPP,
so things are modified without any lock. What could possibly go wrong?

THe fix is a bit involved, and relies on 3 things:

- Making sure that the initial affinity of a VPE is fixed at activate
  time, which is done early in the life of the vcpup, before it can run.

- Add a per-VM lock that can be taken instead of the global vmovp_lock,
  paving the way for a more manageable lock order.

- Take the per-VPE lock whenever modifying the VPE affinity, as expected
  everywhere else in the code.

With that, VMAPP and VMOVP can now run concurrently and still lead to
sensible results.

Marc Zyngier (3):
  irqchip/gic-v4: Always configure affinity on VPE activation
  irqchip/gic-v4: Substitute vmovp_lock for a per-VM lock
  irqchip/gic-v4: Make sure a VPE is locked when VMAPP is issued

 drivers/irqchip/irq-gic-v3-its.c   | 48 ++++++++++++++----------------
 include/linux/irqchip/arm-gic-v4.h |  8 +++++
 2 files changed, 30 insertions(+), 26 deletions(-)

-- 
2.39.2

