Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013040.outbound.protection.outlook.com [40.107.162.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE283B3BF0
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748248; cv=fail; b=ovhwUqlwXB9QqT9pyC0LWPjNBxOrWb15CZfsfF6lPy75Pgi/Jsr2/1nFLqh+mlhjrn2ZVsr8PVu2U1cHvX/jvV/C8Ozy0l/SfyFTXYyxkbXLgR6vTCnpa472eWFfiBTlGyhYC9pAAPvo5lAeK42/pLS656dqZBRN9WqZzfpnJ0Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748248; c=relaxed/simple;
	bh=E/AXri3qcKX0aNhrdDJGLng9mXYCorlgJVyL+mL4lRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R8e0jklxx7Ae2J7OBG9vtVODHRT9PCESg9IOs6pRktaimYkEDKBsBw6w5Gk9VRbkqmIfvbgRJRUcYT4WElBQuur7x36DoaBEAetieFimtkYFlPTL/KqinmNdKE0+97VC2Ezw5ys/Lk0z/P2DsXleAed55dic46gnFE+xgLrauq8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dvbK1F5K; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dvbK1F5K; arc=fail smtp.client-ip=40.107.162.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dvbK1F5K";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dvbK1F5K"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EXgXWhh9lcMFuTch4GbPYtHB2XHdWna5rOnnSjwc+cc/MUhsZ0mFcj3OkUklSa/c+G56ds9PdFMStIydTjiSRSBO3hZ/uPxpDKWLuvhi1o/ywyzcqibqHJ9kLz6aMgbYTd8wNFXB8YNxjKwwcN66DxpHBfEUem2z7PCoES2qDqo87riypYolyzoV82RMfyh501e5D/Hsm68+JjK2iARRa7L+EzL2eP7OV3ScdxmJCMddyzElEuhicyN8Pjz1Moc114xhtEoH4lqs4Us2iu2dJPqiR1nnloheqefolV0sAP1k3O2Icq6UV8vkqS4NiTrNnWHBEnLGkB1Me/BaPOLWNg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pciCuvLTZANniTF49k486dIrIwxLMGKOgPbRsXS/5/Q=;
 b=Ipao70dhE9N/LJtWw0mCocjVJ69OQHbTboG5VZIz0A2IPyE2Bug2JrqdtDY8c3/047WTXeTT3LoGynFTLm3L4uzTCxebkZ0fVbfuUMW1Er0dLo470OiB6dIh7sXsPOYPgH3YtkWJi5ytq/yTZxBn6EkPug2Uct9+rc5IpbVfocKVC1SeHabR5UHVikKQBG1qLql0b7R8BqWqv5pjm/m8GDQNR6sSzMNrg5kcV6vcCgn9DN8cNwLQulNaTLJJWKFTYT3KmA940UfmmYRRaOEdjmgsmuhGNjgKRS1kt8H+XRTHgkZptAlgBEMufVnr+/4W2D4vfMOKeheWpM1RPuJ3mw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pciCuvLTZANniTF49k486dIrIwxLMGKOgPbRsXS/5/Q=;
 b=dvbK1F5KykBoutDhrXTLssj9ZoS4Fo8TOdR4PkeVk87R76kTm+IR2mHxx7gxH5HOOsHz2/bj4j0d6S8q4gPFe9V+5fuw9X/NXCmOhAWUNuJ9lTri6fp8Lqbq81cNYnEykcHS6yzJHwU+/ttG8TturLAG31zMzcR673cJJmDllEM=
Received: from AS4P195CA0036.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::29)
 by AM0PR08MB5444.eurprd08.prod.outlook.com (2603:10a6:208:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:50:36 +0000
Received: from AMS0EPF000001A2.eurprd05.prod.outlook.com
 (2603:10a6:20b:65a:cafe::f3) by AS4P195CA0036.outlook.office365.com
 (2603:10a6:20b:65a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A2.mail.protection.outlook.com (10.167.16.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AcF86ozeKPZoCG+82u/FKPQb4y7KXLxhqOkX+11mv5vgdLhos8kXrUByLCI1jyEfWLC1+x/DfZXhFSlxJRhuTRfonEREyCVBajBW5/mVVfatb0b+cm3v2sAhRiMwppGpEpj8PFM1V3Y6mEfZp0X8tGgOzlIG9/pgmmhgt6m3fNhJv+YV61iNEJw1KslwWNVAO01iiKGNjbAZrtzRf+UgVXYoNBgzDct4Idmkg7imXFnR7wgeFlCSxuFR8ZGYPFDl7FXL8sMkvzlsl3+AlXDZisxYCkOrAPrXT2QLg//gs+JnjD6gB1qy0QMLeU801fUtSc/FAQcXRabKIlECdIrGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pciCuvLTZANniTF49k486dIrIwxLMGKOgPbRsXS/5/Q=;
 b=kruzd1Qo5g23cZRsKiv88woRqKgETvjkWG0lYMECwnSrrUjFmfaFjlQTUBWmyLt6OVLeGHS/TU/OuEvZ8JWGgxTfhCnzitEDIaZo0xAfkxPQRgIrqb8BYsuwU7y6Afe+DP6KH5KAhX/DXidr3Ues2T8CGYNwThNOCaTypeBiUGbL9brFBmoYnUuVWVf12RaHGwEm8ybInOq8CWTJ4JoZSSkw5S5azfTdqDMGfhMezA5xkNzTx0bnVxCIHeDBjmc1bADYfitg+CGv7UCKqqCDmoR59LkOwX7Ox1v7oBEVD1ZumnINUb32+7ijVLTc1P9cR1UznWFkv5InsiB9mbNy/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pciCuvLTZANniTF49k486dIrIwxLMGKOgPbRsXS/5/Q=;
 b=dvbK1F5KykBoutDhrXTLssj9ZoS4Fo8TOdR4PkeVk87R76kTm+IR2mHxx7gxH5HOOsHz2/bj4j0d6S8q4gPFe9V+5fuw9X/NXCmOhAWUNuJ9lTri6fp8Lqbq81cNYnEykcHS6yzJHwU+/ttG8TturLAG31zMzcR673cJJmDllEM=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB7674.eurprd08.prod.outlook.com (2603:10a6:10:37d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:49:33 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:49:33 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 37/39] KVM: arm64: gic-v5: Communicate userspace-driveable
 PPIs via a UAPI
Thread-Topic: [PATCH v6 37/39] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Thread-Index: AQHctgQfLstdM26e+Eir4oR7+hHmuQ==
Date: Tue, 17 Mar 2026 11:49:33 +0000
Message-ID: <20260317113949.2548118-38-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB7674:EE_|AMS0EPF000001A2:EE_|AM0PR08MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d653937-ec50-446e-7631-08de841b6758
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 MQJrlOIWGtwp9r11Vk1cJ6wx6kGq9jBQrmoDdbVRZZrysKdxQckjPmlFRXXeN8Seu6wAHm5v7M4QET977V7NG25c+wUOBCNAzQLrj+MGjvlWf1lAMTAz3G4gl8Is2I13Rpg5PlxmBkRLnJLLBQ6AQEsOVBKfNumZ41II5Lv5zahppxPwD+91CiNI98mgBs+3RD0YCSJSTAG594PX9UC7JuqwuFeT2o8qTzrylGqyPKO+e3+2zxsFHqFwijGJxstmfW2aFCHeJKt7kJ1IoYFcDvwUSsCsaGcH5oQVOeKjK15jku2tcvrOTRGLfD0Pk3Po+nP85JMR0mUKFCAEtFy47pUlUnVrsWDq4vACK7LxEnCQwVJ+vWH3o51NyxNUKshJXA5NpmX1l2BvXAhvO7RQ6KZQN3eVsDikeKGEt/tL8MDL/WX2dfI1ywkRuqSScARq1Mies/eCCHYzbARQLWaMr05idkm45U1K1eq9TMfm+8wNJ6dFJrA/0mkV4G9OR8TpaeKPlOnQvW5CQyRLbL1EeP7BOpKyg9rKove7ibY8kNDXFejeG2+5//GkkSuO9XnxCrWmw0HOhEPZ021pnJaZjvTTIe+aqFz4YLpTJC5OZhRfXdRIQOWma8wr8nHTOJXRy1oaOZ347w7aYWszzO0ES9iisuonSZ08sG8tBZt3cRHdb+wH22p5IApFrevB43b3O5BK7wFE0E+Fa26rlY27dpT0iVHwqrz6JGDIJAx9/G89wFOQPWuxmLMbxrjTUCMcC6IIhswbepY99fsnBO/CnUw6HtS9I0IDSDZf7hlsomM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 uzAV73DMiIrWFRQ2r2F1DDoMgOuxADkYmJBMKDcZ3UE1ICsnU04wnS08bdMozGWE1+wWIFNpT3wqJDxEdYV6xzPC2Nk9ADI+vqrNNF0u+OWVKp5JF4h8VavBIofDC+CzdhlkHjfmRCWvvE7WA8W7u70rlkq75NKMNDDvPfpZ/4Endq1hW2yqhQ5bHCY48B//pIL40ejNUhUN38tE15Nk+ydWoUjXSck2VYuBI18EKWIu3wOgMvHX3fdNBQbYW6mTpIytZqsNGNRLG/xk+E+09BSAlolggQBqNiv6ZUKUSygZuZPQtJszyVbT26GzSYv9HFuJ4J7psJ8ZU8w0+zKTnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7674
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dd9d8569-46e2-4bfa-cb71-08de841b41a8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|376014|1800799024|36860700016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Sg+ABmy26/jakJ8X3QuCeYEao/1IY+VwJ+kJk/dPOrrOS5yQwMkk3MFGiPl6MUfEpYWSkMNlktA73+XKlx2cZt5/xMKX5FgRPcZa/eb5V78fwoUwESUwPFhsrNP+a7a5JGBplmtSgOfxhqU3tSzE5j4U8jc4+xrnXpogL4ttQ+0nXR/WlAymu5rMwm0hJGP7h8XWRsATo2tq3di/KCeSU/gnj0wMCO112UL7eDF+rq82RUjYnltcCAb93972u2dmbuo5ijR8mqD0hO+32/jM0aZCOPJ/7Ny+xDA/iLjlLfSpcgRJuJ89oM5tmgmrTcvJF7lTb6RdNs98XN4cpovP6Z03j6lqjc2sIeDuVD7FJz0fQnq+jXS5U8AH5JXnxpm+v+3ujvRGUHtUOT09iBRDPF2TAY4Y7r65YZoA/zJzdszguIv0+Yp8oiSNoS/qpJ7z28ItC7S9y76jbexAidF+Q/7nqq58tIuJ0KxPueosLLNeVXa000vOUAGuDucHui0ieU2UnMSBVy76IotG0J3oH9p4hK65P+gwVjs5M3WKAxknagOv8szx4rv42EsNduD6jXV6SoQjEfxrGVbpjizKWJekTgMx0ZFSUVhgBhspnTW2KJznF9Gw1bvC7N9hZ7sizlSCehteebZixcAQP8eDTsmviWBkBEV998vBGTb3vPfUYdT40nnLbXZqNrP/aymkTY1In5Ik2YE5JFeQAJOiBOZi8L7j0/mWwM+OE/K2K6JjVBUB/IsbFnAWnBQsZ1cSC0TSOxk08oFbD7AofLsXfA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(376014)(1800799024)(36860700016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SDfsqFZu+DxenMTkpXZI4HyrEi7kB1ncfi/RCt1ozgYySFJ6Ne7cX20bsKIl8pcN3wlU0L5h5IWdm+xfp2QzfD1VWg74ttjhrQ0KJ6lioquMevv2h31RYcfQG3vDRg1dBqsCCFSwTV2tXlyI2nN+i/wjim5ANTdClezfwhAxo/Ow/+5pYTH2Vj80Jgdn3aBThIBAEAxQrx+Z1zWBNXFGKnZ5otxTUG/P752HoCrFTcxgcmGzUuR9ebbbuPHOlGS1raHR+fCiAv/CeLyL8Rj9geaAS3JoxFUMVpa/MJvBqEUHJIwdMw0SQ7Bfu+V+R9/sOyQIBDuYU5oXf7q7rxaQmLhsRPDno6acbTfxIrt1ClkKyvCK7chFrOvvcJBmX9jd/x/WGHOXgWwALaaj2xDbuSOrTtN1uW72ZCzqE6ABeJdFlUZT+PXP9lSow3CRkHqL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:50:36.4957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d653937-ec50-446e-7631-08de841b6758
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5444

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
any PPIs not in the userspace mask.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          | 11 ++++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 31 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 10 ++++++
 include/kvm/arm_vgic.h                        |  3 ++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277d..29335ea823fc5 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cb22bed9c85de..36410f7cd2ad3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1449,10 +1449,11 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcp=
u, int number, bool level)
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level=
,
 			  bool line_status)
 {
-	u32 irq =3D irq_level->irq;
 	unsigned int irq_type, vcpu_id, irq_num;
 	struct kvm_vcpu *vcpu =3D NULL;
 	bool level =3D irq_level->level;
+	u32 irq =3D irq_level->irq;
+	unsigned long *mask;
=20
 	irq_type =3D (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
 	vcpu_id =3D (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
@@ -1486,6 +1487,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kv=
m_irq_level *irq_level,
 			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
 				return -EINVAL;
=20
+			/*
+			 * Only allow PPIs that are explicitly exposed to
+			 * usespace to be driven via KVM_IRQ_LINE
+			 */
+			mask =3D kvm->arch.vgic.gicv5_vm.userspace_ppis;
+			if (!test_bit(irq_num, mask))
+				return -EINVAL;
+
 			/* Build a GICv5-style IntID here */
 			irq_num =3D vgic_v5_make_ppi(irq_num);
 		} else if (irq_num < VGIC_NR_SGIS ||
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 772da54c1518b..a96c77dccf353 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -720,6 +720,32 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	struct vgic_v5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	int ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	/*
+	 * We either support 64 or 128 PPIs. In the former case, we need to
+	 * return 0s for the second 64 bits as we have no storage backing those.
+	 */
+	ret =3D put_user(bitmap_read(gicv5_vm->userspace_ppis, 0, 64), uaddr);
+	if (ret)
+		return ret;
+	uaddr++;
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128)
+		ret =3D put_user(bitmap_read(gicv5_vm->userspace_ppis, 64, 128), uaddr);
+	else
+		ret =3D put_user(0, uaddr);
+
+	return ret;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -732,6 +758,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
@@ -753,6 +780,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
@@ -773,6 +802,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			return -ENXIO;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index e491ae0e4f56e..4581e51dc6e44 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -138,6 +138,16 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+	__assign_bit(GICV5_ARCH_PPI_SW_PPI,
+		     kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		     VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
 	return 0;
 }
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cc3a7b4d8152..1388dc6028a9a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,6 +350,9 @@ struct vgic_v5_vm {
 	 */
 	DECLARE_BITMAP(vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	/* A mask of the PPIs that are exposed for userspace to drive. */
+	DECLARE_BITMAP(userspace_ppis, VGIC_V5_NR_PRIVATE_IRQS);
+
 	/*
 	 * The HMR itself is handled by the hardware, but we still need to have
 	 * a mask that we can use when merging in pending state (only the state
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1
