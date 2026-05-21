Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013011.outbound.protection.outlook.com [40.107.162.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A71364038
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375682; cv=fail; b=nf4ALT6XHcqyNC9Hsun+R4NEiqv61dVhFN2PcMIigFV7IjyoJSqPjkTNxfzU5XZKiR6yuyQ4suCPUdDWxuXtL5LnAIUjCHoczQlSU3ydlfEAEGES0ejHGFT+vqae8o6EMOhzN8EtrWKnjaX6lVEGUBLJIrc+zLKO6W4IUvHbiW4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375682; c=relaxed/simple;
	bh=/aJWXSqLHLLLgx3vUPCQtdP3+jYpDWDduCUwiJr/sTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NMYoCwdNLA+aLZkwVZNnegf3V0UVCORoUlZkfs2vlNQPyY2QbCen0VkLNzuuwpT5dkaWt8KAVuIby3de9L9fMSQXvrOc+dYoRMPBot2lxyq2SA10KH+xYGj30oGGYIujiiy5btv16LGNMxikFRxmBGYCUlN65/3ZWggyHYsPHZw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cafq8bHW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cafq8bHW; arc=fail smtp.client-ip=40.107.162.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cafq8bHW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cafq8bHW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=qW+JdJRmnQrDoRh4P4YiMcfKoTPPeB6TOrb1muaBk276cgnN3cpQ/eNiP17BL9uJwjs4b9iXeX4f6JGu/uAo39xHkWtyLY86aCk6Yz8PngeHOhI9eSWtlpFbe31MIO/AvbZWVf0VbflNjBIeXNoSYxkcQDYzut5zJRwmLC72/DDnVtpQ0bOBiHX95o8p6OUufq9VyKnKCCY/wcvM5Aow5Ufs+k/hLVDKMqSrmHemg4knEzo+FhhS78Q5yuyPCtb2V8yv/sF6rUBEUj5ljo1rwWNZEcSbTjLLcl9tuTSqNihlW285N1KyW0mh8kP27tsjkRJQ9O6bT4ShgMWE3Wndpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Vh9gWQk5VrnselFpLQM0vAbN5fXuMUV381Xz5gh9jM=;
 b=BwmHaXg3eNr/N/45UmgNv5KEziVhEIvs5zjEN/EFcu+8oDaw4vUMyywfDTaEvbYVRrKW2ldY8Z0CT+gYOQJuyt1w1Mr4nF1qdTzQDaBo6sFodmk/Jf80YC07QlsDxNh/TaqgCgb07yJa2SXohkjEIbxkxg1bNd3mdpJG7YFlv4CEJYyGP+aG5mfqBgu45epS9W16i3rydoQqYidXnR7SyodiBBX/ATPtK/kiMen1tJD70DBPA3UiIPIxevVw78CV9a6Y42fhoKodKg+yub+kaKJBrDZQVyUh6PzWUmGfK+CqlN481DVzW4LX73qYjTH8BqrB/b4+t29TivKQbffi1g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vh9gWQk5VrnselFpLQM0vAbN5fXuMUV381Xz5gh9jM=;
 b=Cafq8bHW1jAzO5CmBIZTx8XYRs4JhI8NVT+OK1TcAXqajxmn/pAGNR7Wo1xCJW77PO9lyk0sphNIyv6ozHc4t4GgJ+hUFl63Z5yfYAeD+u68F5Mz59mZUElDo2dw9oV69O5IrAZgtoNNv48TXHT+HdcwLKnPtmHIO1Cxa2KnpFY=
Received: from AS4P195CA0019.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::6)
 by GV2PR08MB8512.eurprd08.prod.outlook.com (2603:10a6:150:c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:01:14 +0000
Received: from AMS1EPF00000094.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::fb) by AS4P195CA0019.outlook.office365.com
 (2603:10a6:20b:5d6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:01:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000094.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:01:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfr5kBaZcl1Te2q8bueCwHpfiod9XA5Bjyoizuchs+myXaG5tx5Lt6MUV5T3aQr+EHKEdmKhwec/aosgw2w9oWEqcDpofiyK3MIkiOZxlheSfDxbH5IftInAzDapKtudMFCGTEzo9HiHimqVehEK7EM3piplK2bjPLHvGkdW77HRtv3EtkRtqFm0bARD8J4qLghGwR1TjHnAXiySIwLxhSVWYW1zxTFWMsDqg3g0Qqb1zrerSIPLFmmFpUwpuCj45GjVm3mFgZ60Km+EEpKTPBrTrBjWuz69F9Z2NfiMaZr/8SK4iZi/0uQSIsiXddf0FSvbL2x7J33MoZTfCTinZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Vh9gWQk5VrnselFpLQM0vAbN5fXuMUV381Xz5gh9jM=;
 b=DfoqCaDxulwi7j+6N8rKiH1o2roBGFu3ZBU88wXg1wL40QPxlSF+2RoQcIR88PvqPYOthFPmmNn19ZkTLVTwCx0gpHfn+QjAtyT6v9F6RmKXwyUXHdkw+r0Sj70czTlajIiCaaZ1kM7u3NXWsjvv/AEJJ01hzBb5Y+3Q0+3Y3QeWZ8yjOSU0HGW1fEsOeERsJ/+Q14TjwCbLl+Gt3YYEuu2QjlFUAdPBveXTKvmuZ61Iz0wgp0y1IakQatEaEbgkTTCdbJjlQJVxzRkt9V8mvIBZasX70Ry0B/LK5JW3GnRujEk356qGainBsc5frtaYlAkkLcZ+MhkvehuXObPLJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vh9gWQk5VrnselFpLQM0vAbN5fXuMUV381Xz5gh9jM=;
 b=Cafq8bHW1jAzO5CmBIZTx8XYRs4JhI8NVT+OK1TcAXqajxmn/pAGNR7Wo1xCJW77PO9lyk0sphNIyv6ozHc4t4GgJ+hUFl63Z5yfYAeD+u68F5Mz59mZUElDo2dw9oV69O5IrAZgtoNNv48TXHT+HdcwLKnPtmHIO1Cxa2KnpFY=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:00:09 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:00:09 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 32/39] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v2 32/39] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHc6TKEhj4p6ZGfOkSD1ZYPD/hmZg==
Date: Thu, 21 May 2026 15:00:09 +0000
Message-ID: <20260521144846.1899475-33-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AMS1EPF00000094:EE_|GV2PR08MB8512:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f99212-9878-4a75-4e2f-08deb749cd96
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 1m6heHf4bgvmwMKbLOOt25KZgTrplkpuJZ1dmD7/ZqKCTfJtMCgmeON6sSmaYDwYPvBYfLjMaUePakMs+yoL4ZRjHge0P+B9IwNoNrvevpPKhnOfLDtywLI4dJveiBH3DE1icyIhfZnCQD3vzH3F9arS9MUkVpx9bcHenPEf13vZUFuesBscs5lXsftw5m0PglI2hT5m3mqnvHTg2hi0bkjMZCY4Lm/VNS2dgdLSXLHGeXRHwrxyk+SVCikFDtx6Tqns8mVb/DeBtRy/bwdbjp0QX7/35ilU6cCRN/gqGKwmrGudJkH70Ssn6LmzJfBHIt8Nfu62IeiOY5acCA6RsKbApdceau3vLB+u3WKxljZXNDx6hXNbx9maNbqE1mBke5Kcnc01pAIiyo/+JV7mzFBye3D4Msz5WMHyjSmA0jwOIJei+6Kf1s4KXPF2L7Sx+oQhIQuyl3meAi09/5qw8LOvdrqUKtHgokx+g1AVLv71rrrvMikzXHc8zWrfA+X4s+61zbwE/ZeZaYjPHJFwsLpAV1U6fQ1eXlu/88ShP8MMhilO0sFqH8PLgzPBM2DgISyiW0RXevySOdtMNqwxx7YAYR9Ft24/OwqfQY+ublkwFV6afYKbDaEP43uoyZo5sZ02JSVDxnkq08/FoOaKhvf5WBxuxBYKtpXh7u1qpL7RBSXSi8TxDGNbf2KQb8nkNslwcXGjGfWYk6FzFONOtaKMr/fQvrw7ucYtftIov01bD6pGIaV/UdXYPQwaBjIr
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 l3xDxRTk9tAOvNzZ7i+FBm27TlBOWxljctIjBJsFKG6QjtyS8WaTmy1vzu7N+Y3uZLiYrn3TBJH64vdPAPHkuV0RB8Usv7tYHztvdXPZKS2IPL7Jbi9rfnXZkRUZ/IQl9YcNWyxnVicX4czQsRPpvR44J4s7OLEdTMf914VMQAEg2/Bji/zAJuqLW5jb9BXMlWIf3hPgRHsbGquhyfK5PdnzzGP8GiTPLEAtLJYtP4/xCDxrK2QneZ9udRHQaV7bD5Wb4jXyReyJ5SZivi/LFkOara7qVO4rPruprO1TmvmaAobSVluNqibIjM70g8qz8OSkcSViSp5TWwwmpOuqSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	26d6aa49-2f7c-405a-aafc-08deb749a70f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|35042699022|36860700016|82310400026|14060799003|18002099003|22082099003|56012099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	iEEBgx434Bvf8wnP3dDdqET+YDyj8C13GGb0R9cNF4iLYv3a5XRD+Q3s2A08Eznv0s8asGWQBemjP2tMqq0a6R+9EQJ+bJDG07mbmisEQ99hMUvzwYXaRW2aS3mYro8ppk1vrIp10rjp18ztYyiGNUKMYuZh8VKCUDch7tDIpjWUwUhDwMUa/nyfa+twdEIorsefPkaR9mbUWwA719R2oQxTcnGvkZIT8pWcT/6s5UYjlOA8+hKfZgDj87IzUhllIFD8wRvBHdrvhyw6vvxunLL6Rn/aElXSXG0ELjbvmp/HGxSqXLPJyaXNP2u9H4okoJXQrbMsRtuOBAS0A8XR0UR7BmqEoGYG4M/qRl0f2t5uJe7oEXZ4Jgjl8L9BQdESD404rHzD2rgpu7/2ULa3X5ptKehh64pm0UZ3rVBzRoM3Uml18LibP2TroRAxOKX3Wa1WuSyV1mU1UCzdKwBur7vO7PKUrHnjgqjyy4hiFuuhYxnSy8CYcvTktRK1nEa0BJxCbFHnFcOZ7vxpLpYAMuSQNfbNFDRgtLoBf80CHOAAM8W0LCSzfcyrsoJwhBZpXkm1luAJQupmzU3822qHjsrsUUOhzd8Yr8Yz31KDcHCQFA/hbZg2s5/u4ncdVh1D6WCDYlk6HYsbBUJ1FAuvHoclzfGY61pAUaq0uiAwsvqmenVXT/aoQ6OJ7ChRwNaXRD3M0odJG2gRvlqsnEDAhtBllFKDHELkB5Z2ReAwwhc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(35042699022)(36860700016)(82310400026)(14060799003)(18002099003)(22082099003)(56012099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sb6LlSyxqqc/Rk4ByNs2CbS0NiG8y1njSmeRmCUl6pPtaya8MOKYJYCQXTRkNJaLdVOxKYucI3liiKcO4SuEL/rTOqKxkVuciinHeZPwPtotnyg/L+6t1hCLaBMLDRB8fTc4h/bPaE7TC87TfYDKszT02UHyNpaVMyopL04dHAptiQzVKzBZWYxVS9jXihh5d5jopfvNHBX/P85zbR42MWJblF1DervAb2rzAvNUgF7H1nO6GAHJs/tU12yx5gyLl57MjhT0QSxZiiHTUXBOk4raIG1hf9dnDixadSUD01Slj2W0TFRddfRgznve+66LNRwGSjCHvI76uRGpGuhs97j+8IJp+VL/wWOfGWixRttTpkSiSWPL8XqwMy8oy/6xizB1UEM8WWV36QQ47ISdshEC/+riAxAbRG8pBTKVj7RuCpAKhoHGofNMNlK49CTm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:01:14.1833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f99212-9878-4a75-4e2f-08deb749cd96
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8512

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIs are considered
by KVM. Secondly, only a set of those is exposed to a guest - those
corresponding to devices that KVM emulates (timers, PMU) and the GICv5
SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied to both hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

As part of introducing support for userspace accesses to the GICv5
system registers it has become apparent that userspace sets of the
GICv5 PPI registers can result in a mismatch between the state exposed
to the guest and what KVM expects to be exposed. Effectively,
userspace can set the Enable, Active, Pending state of PPIs that KVM
has chosen to hide from a guest.

Under the assumption that on a VM restore userspace will set the PPI
state prior to running the vCPU(s) for the first time, rework
vgic_v5_finalize_ppi_state() to not only calculate the mask of exposed
PPIs, but also to clear any state for the non-exposed PPIs. This
ensures that only the state that KVM intends to expose to the guest is
exposed.

Note: If userspace chooses to set the state of PPI registers after
running a vCPU for the first time, then no masking takes place and
that state is directly exposed to a guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 34c9950884d5e..2a9cda1972b69 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -958,7 +958,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6e2191620e8d7..05fd10030da84 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -761,9 +761,10 @@ int vgic_v5_map_resources(struct kvm *kvm)
 	return 0;
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -772,35 +773,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f9f58ca793707..eb68c96a46ed2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -783,7 +783,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
