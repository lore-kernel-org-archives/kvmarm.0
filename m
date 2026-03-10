Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70733DB629
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146997; cv=none; b=mpO/0JXnfiA9X5nIIy14kqKDWB+2g1GPXRBN+mEVpObQJR+btCMUYLJVE5r5cHe/gg5TbBrVnIj7M2CmMZA0ekWD5VkSxMtW65GmRFLEwcnSgBFsjU2rqvb6kKoG6Cl5Hk5auV8f1EGBu2u+KH7Dkt4gpX7W1OtPiOWcXEwioRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146997; c=relaxed/simple;
	bh=FqhVbu0S17LwSG6J6Va7LEFnxXYCF6iCNTZbU4gGMEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aokRjU8eOdhX6pLrug9IGhdmei5vJiBHA7Y1S3UrVufpEjJkvLwe1G8EGDIh7/N/P5HMTN5HEXZcijNkUjXjmYZAf/GNsAp5AnfR0F7NXxM6Vti8Pv+Ub9MDU5RYpd3LwcN0Sxxe4WmFFKsLdT+/TuhY1649xh0UhpyFh5iGG88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PRCkgMwD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PRCkgMwD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4853ac455b2so20349615e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146994; x=1773751794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cabtoOO69urPXAXi1nwx09QASEtiR2iqFRPNp+1JRfM=;
        b=PRCkgMwDIxQ/cPMBoMtrh6RAO7F0WroZG6ik6q8RdXNiMBtfgN8ZuJtCWDPkTSPR/+
         hCuahANEilA2lyMp0cUPYRBe1VvWNz/LvJTpENcpuvrJQSsGZWymVsFXX4lSCDYMCARb
         R/3bGzcUY9eDc+uyOTEeL4bL6xihpAIRLvQXcN9BBgl+APG3zOtyP0AIaCvJ9NOxrz2p
         H7xl+AjvGwbkVfm4khtjVZ3fmTKY+a7rwIpRiM9nVuocOs2Y3XH779lH4gQ9w6Y8Ui6Y
         z3ilEfH660j3KAeJKx/4CuTDNVF6iJ+L+RWt9fRqbykh49+re1b1/Gy/AAx1LizOEBo8
         61QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146994; x=1773751794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cabtoOO69urPXAXi1nwx09QASEtiR2iqFRPNp+1JRfM=;
        b=RpexN+YmZ7chzDQl5LARcjWR5gszAnjwRv4umgMlaIs3zxLvYDHoVRPIOgImFMkYAC
         uzLzHikoeYtLVHqmJg3MJ0PeLIbPay4iF3fieNP6xkGoMjw7ldCYdocjf8vjf70V2bhU
         uQeOW7p5IrXO0WPvLmfKdLlNoL81pNvVGNtUdghOfiqf5uYaQU8iTnWGfVVQ06KhCQtY
         eqzk7N0Hw8iPHUrGBC+kyJvNi3Ul4rBUntctqznbapVym5TDHCp6WcLzZhblwk1oho44
         TGxzJe4/7Fj6u8lIzIvpGU5y6QTTr+niBOencMppHd+XIUuYOixMAoATv372QNq09klz
         QKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMy0uAMca9F/sfMMLtqFO236h+jC5tl+9vxvlIiGndxttuGn+dNH//HUSR1rr5BH3EwZ3unCY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaRI9YKLI+Z4kroR9IEWThbb3GB4jjzKq7Edk6rtaUUd9A97S0
	YeMuyEZFdlPjGGYP3RaxjYyRH8w6+C7gH3ixXNVxXugz+oyxFrjMhCTPoiAsiU5V1BQ1ckgQ5nB
	JzoUskCS6F1icyj02iZoan201pdoB1A==
X-Received: from wmbjq3.prod.google.com ([2002:a05:600c:55c3:b0:483:6e28:c16f])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:350e:b0:483:3380:ca11 with SMTP id 5b1f17b1804b1-48526978900mr254229025e9.33.1773146994098;
 Tue, 10 Mar 2026 05:49:54 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:29 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-11-sebastianene@google.com>
Subject: [PATCH 10/14] KVM: arm64: Trap & emulate the ITS MAPC command
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Parse the MAPC command and verify if we need to do any
updates to the shadow if the collection table is
configured with an indirect layout.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 7049d307a236..4782a9a24caa 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -198,6 +198,13 @@ static int process_its_vmapp(struct its_priv_state *its, struct its_cmd_block *c
 	return track_pfn(its, base_pfn, num_pages, remove);
 }
 
+static int process_its_mapc(struct its_priv_state *its, struct its_cmd_block *cmd)
+{
+	u32 icid = cmd->raw_cmd[2] & GENMASK(15, 0);
+
+	return check_table_update(its, icid, GITS_BASER_TYPE_COLLECTION);
+}
+
 static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
 {
 	struct its_cmd_block *cmd = its->cmd_hyp_base + offset;
@@ -215,6 +222,10 @@ static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
 		case GITS_CMD_VMAPP:
 			ret = process_its_vmapp(its, cmd);
 			break;
+
+		case GITS_CMD_MAPC:
+			ret = process_its_mapc(its, cmd);
+			break;
 		}
 
 		cmd++;
-- 
2.53.0.473.g4a7958ca14-goog

