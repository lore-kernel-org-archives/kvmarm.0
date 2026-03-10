Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7683C73FE
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146995; cv=none; b=o707a60MfMF2l1CR3TrYBwBtJrviD39QIuYwS106ICIpMYxd83+hUXUJ6lJS0M96FUmABjJRZKY34pZ+9RY4CjQGqd2wuXXxFFP6Pz/uYcFTykhvk9HTdyoyctAkmKhzGrphy03MjH9ktcoR+cvaeHjMyaX0jyXOb6Fw/868jOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146995; c=relaxed/simple;
	bh=k6UwhIhhsfW0It/EuFgaW+IK3aiuqQqET1Q14sl0QXw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FSkuUDWuPx/Y+p+1XjciWxX/no23iUwsClYlQnk3FLjlGAR23YE0WXDRyqqcoXJlo+uRuj2Mu8Hu0ivXwsca3IU1H6OB/DeS/abPT2ng/iqal7ZHLK53Si2j7Sv8Z9c53QnD/OYfS0UDnGLM9GlXPBXQwawLvOVVZUFmDBSFo8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZzxYpH4i; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZzxYpH4i"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48534941525so24931355e9.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146993; x=1773751793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMGGQ3IiwT5PMH1OcoXP65zz2QzMpSJC2ga0AgyGkCg=;
        b=ZzxYpH4iUWZ9ldyZ7w1bbCKL1C26MFaffmS0SnBZU6kxnF2qpLKNNRGjNwz/x0cuKs
         YFHb7FkxRrkxRblGiZ/QRXcLNPMk7YktLiZqt2NLoHf27N4UYvBmxrebqBhPAbd5MUF5
         OGojsm0KUdiCYRxknLW32AggFrFBjgggGI9WV/Nrbus5GTywp4yvZTiNPIENZrRYy7US
         tWikT2yFJ0tJ8bcj2N4wCla0nfrRyh8PbYIMPr1l4HaA1nLZNVaEjdZz+Eut4l2INx5R
         v4Cxl4JyQy9WvLzncXhedlSFsWbZoge7G7JH/qyQTagEjltmCf+FNZloV5c7j9/nZiYZ
         lDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146993; x=1773751793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMGGQ3IiwT5PMH1OcoXP65zz2QzMpSJC2ga0AgyGkCg=;
        b=aKjAnfXKVCikPXPnZD9qDqgtt2V3ZrM/Pk3yPnZNiqtXZhglJHWQHCtkr1Q43t2W5L
         V88ouBs1Hl4KenxFj57+k33PmfCIiTJbaVwmGw7A9MR+PUQzneMuhV8UEwd0+TxkJff8
         ShvMXlLVGKd3b2FE7ezKMtgWIoLZSzSKuPAZqUEDInG92iSk6ad0gZ0PimOwFFy5VkEY
         XSIiOn+frdwUvxEvmfHbJnoz5R2DNm0ugfW7cfBl/O75oz/50JOqFVRSRa5sWBSGsagG
         VrHg4LI0J462DFPIpmv/BDULDsR3DIfNSQ9O3WYNLR+HK0WonU8jWgvWnVl8wCNwwK/C
         m/gA==
X-Forwarded-Encrypted: i=1; AJvYcCUIkgwpNVkjhQiNvYD4zZLmiXEwuf6+ZU0p+vpPKpMLeUHK9OewdkhRsuDWbYjs98aAhyxxqYY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxiwrsa0CVWDqZviWMFaM9r5HDvht6gafhmvy3LpLaRPVgDvzyy
	5MqLeq4GPrnr27XQk/QIC0dwA/SXUbRlsBrzmKOWTEYYE71x2APTE0k0ohSTgQGJ6159spKbTr9
	/KMIwt0BDVf9KmBSBbKJ149qAsXwNmQ==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:485:4553:1a97])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6383:b0:485:4526:ee06 with SMTP id 5b1f17b1804b1-4854526fc21mr24095095e9.11.1773146992719;
 Tue, 10 Mar 2026 05:49:52 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:28 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-10-sebastianene@google.com>
Subject: [PATCH 09/14] KVM: arm64: Trap & emulate the ITS VMAPP command
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

Parse the VMAPP command and extract the virtual pending
table address and the size of the table. When the command
has the valid bit set, share the memory that holds this
table with the hypervisor and track it in an array.
Unshare this from the hypervisor when the valid bit
is cleared.
Check if we need to do any shadow table updates
in case the vPE table is configured with an
indirect layout.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 722fe80dc2e5..7049d307a236 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -178,6 +178,26 @@ static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cm
 	return track_pfn(its, base_pfn, num_pages, remove);
 }
 
+static int process_its_vmapp(struct its_priv_state *its, struct its_cmd_block *cmd)
+{
+	bool remove = !(cmd->raw_cmd[2] & BIT(63));
+	phys_addr_t vpt_addr = cmd->raw_cmd[3] & GENMASK(51, 16);
+	u8 vpt_size = cmd->raw_cmd[3] & GENMASK(4, 0);
+	u32 vpe_id = (cmd->raw_cmd[1] & GENMASK(47, 32)) >> 32;
+	int num_pages;
+	u64 base_pfn;
+	int ret;
+
+	base_pfn = hyp_phys_to_pfn(vpt_addr);
+	num_pages = ALIGN(BIT((vpt_size + 1) >> 3), SZ_64K);
+
+	ret = check_table_update(its, vpe_id, GITS_BASER_TYPE_VCPU);
+	if (ret)
+		return ret;
+
+	return track_pfn(its, base_pfn, num_pages, remove);
+}
+
 static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
 {
 	struct its_cmd_block *cmd = its->cmd_hyp_base + offset;
@@ -191,6 +211,10 @@ static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
 		case GITS_CMD_MAPD:
 			ret = process_its_mapd(its, cmd);
 			break;
+
+		case GITS_CMD_VMAPP:
+			ret = process_its_vmapp(its, cmd);
+			break;
 		}
 
 		cmd++;
-- 
2.53.0.473.g4a7958ca14-goog

