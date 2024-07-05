Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F671474B6;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720171922; cv=none; b=WwDAzb1o3VRmbr6lyOfbsOsmV8kjQkuwgcTuXwiiiRuKXGc37cUdm/+cDfXC2pjfrjsqzFoPxa8cPyRIjjK8CjkrIMa6PBs6TxYkD4clOHKX+T2swKuqcYkALniYvjtOLhRWyQxzUp/C7Bm0eCWHfvot93NTgoMlyQkl8ABgDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720171922; c=relaxed/simple;
	bh=vXaZypimdtDEFoahBdSVdRJ7Rc7jfwOUM1aU//Iu5Fg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VyFYYMa4OYvuk4p+h9URJGWCZvlZjVhHHiziWS+Bj7yQ4MnGd0KFDnmqgocrrGv1NQcx2L33SVro0JU0kyr6k6Q9p4fhnqBRmRUTV20U+XsvpZTi/MNMTPyATBnVDLuutMVriGV44c+xKR2Yypx48lBMARidsSwwIii4d/l6HJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgscsyC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgscsyC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7940C4AF0E;
	Fri,  5 Jul 2024 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720171921;
	bh=vXaZypimdtDEFoahBdSVdRJ7Rc7jfwOUM1aU//Iu5Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgscsyC1n1k00NijCvI/9W6kFbsc2kpaZLIbXxkYsn6HxWp/YHhaDo54s+hzxCenF
	 howYQHnUDCsn+kKB3Vg/+fcB7IqQpud2nBDy9zo069ZAzviZ4iDO8LtyfO87tStXuT
	 OLnla40I0m1hscgu8LeHGTEReWxkaMlvmIQxFlwOOJQeMvEJJt1hC3/iPGYqSaAOX7
	 OmcZhLHw0Z2/FKNJ6qPIvwkNl8+uR3tt8cL49Zof5wm3+fAKdTMiqGEEwR5ffAoP8Z
	 vpFyS0dhtYjYkbr47FJ1B0VIa8UyBzwHFSyZOW3AOwFhkHhQn11VVyjjotEqkcJuip
	 CujJXmwVB8AIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sPfIN-00A0NK-8e;
	Fri, 05 Jul 2024 10:31:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Nianyao Tang <tangnianyao@huawei.com>
Subject: [PATCH 3/3] irqchip/gic-v4: Make sure a VPE is locked when VMAPP is issued
Date: Fri,  5 Jul 2024 10:31:55 +0100
Message-Id: <20240705093155.871070-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240705093155.871070-1-maz@kernel.org>
References: <20240705093155.871070-1-maz@kernel.org>
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

In order to make sure that vpe->col_idx is correctly sampled
when a VMAPP command is issued, we must hold the lock for the
VPE. This is now possible since the introduction of the per-VM
vmapp_lock, which can be taken before vpe_lock in the locking
order.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b52d60097cad5..951ec140bcea2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1810,7 +1810,9 @@ static void its_map_vm(struct its_node *its, struct its_vm *vm)
 		for (i = 0; i < vm->nr_vpes; i++) {
 			struct its_vpe *vpe = vm->vpes[i];
 
-			its_send_vmapp(its, vpe, true);
+			scoped_guard(raw_spinlock, &vpe->vpe_lock)
+				its_send_vmapp(its, vpe, true);
+
 			its_send_vinvall(its, vpe);
 		}
 	}
@@ -1827,8 +1829,10 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
 	if (!--vm->vlpi_count[its->list_nr]) {
 		int i;
 
-		for (i = 0; i < vm->nr_vpes; i++)
+		for (i = 0; i < vm->nr_vpes; i++) {
+			guard(raw_spinlock)(&vm->vpes[i]->vpe_lock);
 			its_send_vmapp(its, vm->vpes[i], false);
+		}
 	}
 }
 
-- 
2.39.2

