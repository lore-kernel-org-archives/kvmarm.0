Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F362F1EC018
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101906; cv=none; b=cJtrXoEj6upvsWih83wH0/vBeTROdseUCAqDRowkNyaDJ3iUZrdZOJGkdUlScvHMBRPbDAwkPdekDIA3sIRLwMxBWS/RPOd5HV0rnRCdATX1Xq3LYNiAkRjA01LEeFyFzDt5/To3gDuiHVdQ/Pe/TnHc1X4amZsxwibpHSAOwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101906; c=relaxed/simple;
	bh=hW2x83jQhydXVuyRaNAVfliRssGPsVWJxnzSeknKQLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDj1oqGHP03UG0Ek+wrghABTqZqyyaYpjwJaHvpZmC7UIXKzFTrC1i60gqh3H+1vpnA45g9npKAiz2lYPHPyH/jh8rpsikYThgttggyb9rKcwPrmOqWNXNBYHGjdZKWyR1pkTUt/eqdqBxk+bF2hkjRlcKCFHMOnQKnHXQ1wsU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hf42EYYK; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hf42EYYK"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3bbb0f09dso2856962a12.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 06:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734101903; x=1734706703; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTU9/5MK0HAWBhEVM0w6Se/hTXoo9yj/PJnWYE15UAo=;
        b=hf42EYYKq3vyjoaEWvOG5y943flNjERQfg9Hxag9CPwen10zGAqNRtg+uJT23lu7rA
         ltEe26vby9pwjZ8jWO8w2kYtHPqe/yjOgbXWrdytC2Uvf/q4+8WMccQXvkwr/8YW4nbg
         d+pIBqia/O9r8zThj18uHhzwyD3pPmRjTAzbllbUdrKiPQxYxbyMxVtcR+srnRiuGHCX
         TWnjSmw+UdYUWFZjO7evN+H+kthBkPXCW7ACX8DjA5JlsWSqCrNS+1RHgYiWqFi+be2U
         opm5Zw4x9AgPhGCBpp6Gbq+Q/0hzHplxcPswKoy6fpYqDl8IvtS/sJlP8uWp5r+/NMUJ
         w8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734101903; x=1734706703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTU9/5MK0HAWBhEVM0w6Se/hTXoo9yj/PJnWYE15UAo=;
        b=qPtpbVluY0HqpStUNahw7a7ULcrTmGp9AA3yHVliAHBvYbOHMsVKwNMBR/CcytuoD9
         b6etYEoRBTaA6Upz/CAzKcBH/1SJATq8HRrEZ17X1ydTdD4VyJUe6r3rB8Cu+28c6uiU
         IB7NzljazLEQ2Nwq+i0Riu/eLMNpovf58h5nTNor0Ss8n8lC0r1VV5EJUMiPpdWdwztk
         GHvv4KO5r/XSDQg3Z4eAQaBavf9ycK/mZmy5mNLfVgWgPLxCEpvFZGgE/CiReQzmH6+x
         l9zxtIjWmQsV85+BXXdCiLvVbT7P+CO1qBjH54FMCzZDDjr6EoUJbRMJNiUKIftEWR7a
         o5Dg==
X-Forwarded-Encrypted: i=1; AJvYcCX5iou0RFWQe1NtuvlT9LaNDPSJkifp6pB7iuT7LeXrYJCvi8xbSCZjlQ1jEHS43sz+WIZ+t6s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzkrr8+iIUkaGO+G1sd9j50M/MNhexUkfxAPpQ2TxlvxufkLQFY
	yZ93QV/zaKj1V9twtB137QLv1mnR9fTBVeQv5t60g0RMSG20rBHyJuiSFFf8
X-Gm-Gg: ASbGncstbOkC5jze7veVKB7Dy2Oj+Rt3MLpD2alelslku38npafcAyDBV3/WM2VI9Xi
	wF+OwVnFW2eLzcho3PQDhBzheQtK8ik/203M/jrgaZDPktE1fpCeMSvaaMwTGeukIQbPIjfWgWv
	zBtuXDVkDqDdqsvfsl2vGBR8lbGNPZDW+yEvwXAZ2j8rTfIk2ghCBQdF12JTq9Su28Rxewys/3r
	Ek1H62wcVAENFF/XcWMUJU8x/C+QQjXOWwVCxTegDn1fq8v7BVwrK3x21qkapysUg==
X-Google-Smtp-Source: AGHT+IHAHdTmbS5FyHmI5caY2pFFoYj7IVic+V5ZxnRs/MLkIBNo1DY2zUzOg9k/TR+vdwTA1hoLjA==
X-Received: by 2002:a05:6402:3808:b0:5d2:7270:611f with SMTP id 4fb4d7f45d1cf-5d63c3ecb3amr2620066a12.22.1734101903219;
        Fri, 13 Dec 2024 06:58:23 -0800 (PST)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3cedbb8fesm10048424a12.22.2024.12.13.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 06:58:22 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Michal Simek <michal.simek@amd.com>
Subject: [PATCH 3/3] mailbox: zynqmp: Remove invalid __percpu annotation in zynqmp_ipi_probe()
Date: Fri, 13 Dec 2024 15:57:54 +0100
Message-ID: <20241213145809.2918-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20241213145809.2918-1-ubizjak@gmail.com>
References: <20241213145809.2918-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct zynqmp_ipi_pdata __percpu *pdata is not a per-cpu variable,
so it shoul not be annotated with __percpu annotation.

Remove invalid __percpu annotation to fix several

zynqmp-ipi-mailbox.c:920:15: warning: incorrect type in assignment (different address spaces)
zynqmp-ipi-mailbox.c:920:15:    expected struct zynqmp_ipi_pdata [noderef] __percpu *pdata
zynqmp-ipi-mailbox.c:920:15:    got void *
zynqmp-ipi-mailbox.c:927:56: warning: incorrect type in argument 3 (different address spaces)
zynqmp-ipi-mailbox.c:927:56:    expected unsigned int [usertype] *out_value
zynqmp-ipi-mailbox.c:927:56:    got unsigned int [noderef] __percpu *
...

and several

drivers/mailbox/zynqmp-ipi-mailbox.c:924:9: warning: dereference of noderef expression
...

sparse warnings.

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Michal Simek <michal.simek@amd.com>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index aa5249da59b2..0c143beaafda 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -905,7 +905,7 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *nc, *np = pdev->dev.of_node;
-	struct zynqmp_ipi_pdata __percpu *pdata;
+	struct zynqmp_ipi_pdata *pdata;
 	struct of_phandle_args out_irq;
 	struct zynqmp_ipi_mbox *mbox;
 	int num_mboxes, ret = -EINVAL;
-- 
2.42.0

