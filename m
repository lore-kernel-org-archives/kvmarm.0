Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D162E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxWt3Hmi"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db402e6f61dso8476178276.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548128; x=1703152928; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cL1RM+olJsmQC3rlwUz51qwzObdNnMoFgRZbOyilRC8=;
        b=TxWt3Hmi5jkoZf4AdWNKLAbz0tmtb32MQx78y8i+mDSWvNeJL/6fDBfsuCjLyHS2n4
         p7XJSVSeFs9iTqDLwrm9OnFL7nqDr0gXbpjuaQSdrncE1m3TIK+VjcivIG9osGchb3F/
         EDEjov/BKk79Ib/2u3E3lK862HqcEDPlnUwmPPlXHZbRy4ZL4RBuGj59vf9OhW5Qr0He
         w9Yyw+/kzjHD5i6JK2904J6p0xoOHlDEhVOJwvaFHfcB2lexaAmn7nsnBGoml07uQd3d
         gfzvTLr8IdXrzatdwz9ZGW3sg3ONDFX4qe1oNHh+98f025jb7RX3BT2jYoXqvNvie3xF
         rPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548128; x=1703152928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cL1RM+olJsmQC3rlwUz51qwzObdNnMoFgRZbOyilRC8=;
        b=xF9yWaOgqhjozA7CJ9V3D8WrtRyOiVgcNYlVoTgpVM84K5b3hB6xe5L7/WhZMR29KH
         Q8IzC4uGZYmofDIoRHq3MqEDRTTadQo3Dezd6rSqN4kJt1mxquLZ3Dc9DCZ8fDZaEbII
         O+Yn0YMBJH+vX9ITRnAKd+PgOhugEq7dR4bKzegrLTH0iNlJY13cxmXNO7rohEXTdPbV
         gmP9G9u+VDGdYf2mGbLv7sE6grQL8om8TdJj35ZUUbtH8EspOYgPA02VFJxC0j2Me6rc
         Var80f9mNBKeRisdGW+EdwpI0MVJ5A8eZqYkIBzCA6Pf+FItBA7fKl/HXir/BvRu4NOl
         Qlfg==
X-Gm-Message-State: AOJu0Yx1HpanToHj2Cuxwu/aZFCbnUwLljIAiPO6IHe0fo8plcAPkFAO
	/ZPBaeL/Jaf6mTJLIVr47KTM5G9m3uo2lHtvMglGYmH5VONHxelwayJOiHw127Jn+x6OhuVOZzr
	JTF03joQHy2EMHjMNldYkCiATaid/Xpm6QYGna4+3tLTj9/PlSL//5fO/1XY=
X-Google-Smtp-Source: AGHT+IFdf/kGRovY/XOsMBonsCGOYiqd3rLc8nEiGw7C7DJypFe2aftCAYaDZMQMTm3AeDZLmHSSwTzk5Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:345:b0:dbc:1b7a:e185 with SMTP id
 e5-20020a056902034500b00dbc1b7ae185mr80924ybs.8.1702548127111; Thu, 14 Dec
 2023 02:02:07 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:43 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-4-tabba@google.com>
Subject: [PATCH v3 03/17] arm64/sysreg: Add missing system register
 definitions for FGT
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the definitions of missing system registers that are
trappable by fine grain traps. The definitions are based on
DDI0601 2023-09.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/tools/sysreg | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a8e36640c027..5ceaa1d3630e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2086,10 +2086,18 @@ Sysreg	CONTEXTIDR_EL1	3	0	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
 
+Sysreg	RCWSMASK_EL1	3	0	13	0	3
+Field	63:0	RCWSMASK
+EndSysreg
+
 Sysreg	TPIDR_EL1	3	0	13	0	4
 Field	63:0	ThreadID
 EndSysreg
 
+Sysreg	RCWMASK_EL1	3	0	13	0	6
+Field	63:0	RCWMASK
+EndSysreg
+
 Sysreg	SCXTNUM_EL1	3	0	13	0	7
 Field	63:0	SoftwareContextNumber
 EndSysreg
@@ -2714,6 +2722,33 @@ Field	1	PIE
 Field	0	PnCH
 EndSysreg
 
+SysregFields MAIR2_ELx
+Field	63:56	Attr7
+Field	55:48	Attr6
+Field	47:40	Attr5
+Field	39:32	Attr4
+Field	31:24	Attr3
+Field	23:16	Attr2
+Field	15:8	Attr1
+Field	7:0	Attr0
+EndSysregFields
+
+Sysreg	MAIR2_EL1	3	0	10	2	1
+Fields	MAIR2_ELx
+EndSysreg
+
+Sysreg	MAIR2_EL2	3	4	10	1	1
+Fields	MAIR2_ELx
+EndSysreg
+
+Sysreg	AMAIR2_EL1	3	0	10	3	1
+Field	63:0	ImpDef
+EndSysreg
+
+Sysreg	AMAIR2_EL2	3	4	10	3	1
+Field	63:0	ImpDef
+EndSysreg
+
 SysregFields PIRx_ELx
 Field	63:60	Perm15
 Field	59:56	Perm14
@@ -2765,6 +2800,14 @@ Sysreg	POR_EL12	3	5	10	2	4
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	S2POR_EL1	3	0	10	2	5
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	S2PIR_EL2	3	4	10	2	5
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	LORSA_EL1	3	0	10	4	0
 Res0	63:52
 Field	51:16	SA
-- 
2.43.0.472.g3155946c3a-goog

