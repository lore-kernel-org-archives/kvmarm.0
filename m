Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624519;
	b=KAho+9Jb1T4MoKwCDSuAGqVnH0HVXpyhY5qLaVwL210HoT5zP1+G81H4D2fLVcRif1Ae
	 Z9rX+GhpHS9rfzqb70OuIykI9J/uBG0d8bubyYnw2IH3C4Jav1vAemD2NmbZNR9S/d9/c
	 GzWu7P7xj/9TKlnFpjszIWEPohA71LixEJcsgUnKWb/A2pi/5gF06CKLECj5gntoyMYeP
	 JcGuwCIqlBBaARCwJc14kClWl8IlcXZAP+nWRwkaxIaxO9+DzVvK5k4XjxxZh+uibYOSf
	 ipTSupD/GBLMD7oGBdPTJVUOQ9t8Ybxk0+/bNLzhKlsN6ASKvdHguZ9MMB6KnnYgYjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624519;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=huQ0ijUwRXsaVECpM6U2QYII1iXOy65EuxhrHwpGo7U=;
	b=zPUn+YeYzFNT4WsxyPz+P+/w7TJilecPyM4KQFZJc97NI1ibud0FgPQt1AJ8a6M5s/ew
	 uujWkf8pZB1mShcWZNo5G8Fe78oM52Nrzufan20IeMKJ1ML0XPr07dmzExdpCOH84aY/L
	 n1DmdbHHvQktTM6MldTXcUiZ4X3jYHxnqyKHZQ1gnMzqAEir9kAscnr/qhMSz4d2gqcxq
	 Mt64pghU1H47ZxQdUfZ0D/7z6g9+10UQzXbN3NMOgRtpgfd8+HzMbDE3+sIXsquyVDKX3
	 LQDUpAIm9zfm+x/ncHiKDymHFVl2XQ4pIMOO2cFKX8xWG7u6iXNhsjPFt9WquUVUvlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w1WrA+QX;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C622606A33F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C622606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w1WrA+QX
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UYSZWfHATTfeaAzNdQKHeR6V+/Yl8CVJBkSsVEPXnhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624517; v=1; x=1794229317;
 b=w1WrA+QXLi8ERIeOHNlSSW08IDnMTvbodcd01jDJYbndDE8XcnceRkgwaZajVkfebLD99U5c
 KMXFUK93hcUtJIMwkKzuQK5HQtHivoc2Yi/TxIq/nWxxli5mHHPPm7X1ipChArN48ktqLmRGbNC
 aeuWQAfFF0xBQYWg9W/ta51M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c86092ad60db5f7c;
	Mon, 02 Nov 2026 13:01:57 +0000
X-Mizu-Trace-ID: c86092ad60db5f7c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/13] irqchip/gic-v3-its: Page-align ITT allocations under protected KVM
Date: Mon,  2 Nov 2026 13:01:24 +0000
Message-ID: <20261102130133.3684226-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartłomiej Grzesik <bgrzesik@google.com>

A later patch has the protected KVM hypervisor take each device's ITT
for as long as the device is mapped, by having the host donate its
pages. A page the hypervisor already owns can't be donated again, so the
MAPD of a device whose ITT shares a page with another device's would be
rejected.

Round each ITT up to whole pages in protected mode. This spends up to a
page per MSI device where a 256-byte ITT would have shared one: tens of
pages on a phone, thousands on a server with thousands of VFs.

Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 282e4bafb084f..8cc1bd8e7835b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3493,6 +3493,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN);
+	/* The hypervisor takes ITT pages per device. */
+	if (gic_is_protected_kvm())
+		sz = PAGE_ALIGN(sz);
 
 	itt = itt_alloc_pool(its->numa_node, sz);
 
-- 
2.47.3

