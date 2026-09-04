Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011038.outbound.protection.outlook.com [40.107.130.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0C0492515;
	Fri,  4 Sep 2026 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524525; cv=fail; b=L1Fq7klABC3lzQnEWCY3IB0qq2HJASBHpsFE82GAAFKIskT7y1QaEkJNiXjDE/P74tt6zXsg6mlBVnRYvVhy4ZaCjeAuxXXDA135JqvaU5UwcGnGsyd6e28eF0dDVmnU0ci8xEJtlZRkwhP76G6qFt++TKpEgyssrYG+ZkiDaHU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524525; c=relaxed/simple;
	bh=09pTbho2k1JzgZlBafPT8G8KRw6TJYYiozvuSRH3x/Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QM8RvoJwr4gV8HBy8/10078nQ/3wh8KoRIfe0JhXV6n0RDmm71xeFB7Mn4sgXeZwZywPNEw9UX5hs9UALpL6vmpi8uwwg4ckMx8NianfO2+fW4mtaMCG27iEyvvDgu7rnZ5fxlGdQp0BlVkm/PKXDEHQS86evBH4DBFVi9GDg/U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YSOlFISH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YSOlFISH; arc=fail smtp.client-ip=40.107.130.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YSOlFISH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YSOlFISH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xW3QdzMEy59UYuMYIaK8pRup+d/hyez8eNLiOiAvNg5xE/RXvgfUSSgnPE8pWm5DHHW4UuIhLTuE5oD5fdSoX3sJmRKQk7gGzXRDhbN1Wq4KGN7W9JfFKE+NWnfbMth9whYgRUeFvJN8gYXKx2041VXgt0YSuKUP0HiBt2yDYjzXQ6yEBIAx0rkF4UftvOJG59+r3SIOTEyapt+o0jsXpdwXaQmVbixJtfzuuzYPk6AqF2JYobo+4Pgbry90PK+GiIEPG1XxiRxIV+vzUwIqr9JyJo27S/YV4kgtLjKMMahWCnkyEQIhgVx0t2kspyW7hZrcZ4yzBZreK06pg2K/3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09pTbho2k1JzgZlBafPT8G8KRw6TJYYiozvuSRH3x/Q=;
 b=FKMBQW4d6wsdSy1WWhhyU6wuqSk8Qjzpau5Ovt8aV4XPlXat4fi4K9AS7x7rqBkLQXyi08subujY2ro7wIspaXjs1rE8+7WimCpD56eryuehCO8vBA0M9vV/feodFN1Wq9SQJpCxo/QAN77J9PAUt2p9XAGPNPuWsJC7TTkkP/hPQVW39pxknXFLOpL1IDWzDuuQwr6tOaLsg7+Vu00AWufN4nJgaLNja2EwylW4S+9q2J9MQ0tNT62x2GBCkbjZsZitcRE9KsqakU6GBUEbH0tKJ2AV3NLNvoINoFMK+WE150gJAVttKVYQ0unHch/9VFIsvp3FTBFWiBb7EGJ+Rw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09pTbho2k1JzgZlBafPT8G8KRw6TJYYiozvuSRH3x/Q=;
 b=YSOlFISHP4djYa3U6pyIuMsSB0DFcf4zVbk8wFuiMT6S1RfGAqWKx3DXEdhrRkLwm7ra+LBKa7u73668X0qZ5KUbvwsmr4rI4Y7c0itzYPLutfw6RQ3sr5wuhU8pTbTM62p79w2KWmyVtfCy7w9yGognxTL9avG4jy3mANgfKtE=
Received: from AM8P251CA0005.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::10)
 by DBBPR08MB6105.eurprd08.prod.outlook.com (2603:10a6:10:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:21:58 +0000
Received: from DU6PEPF0000B61B.eurprd02.prod.outlook.com
 (2603:10a6:20b:21b:cafe::42) by AM8P251CA0005.outlook.office365.com
 (2603:10a6:20b:21b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 12:21:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61B.mail.protection.outlook.com (10.167.8.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 12:21:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uL+OvVEJ/DZ2o5/Xhu6ZTaMcmE9hiptJu2WEnnuYsCnbITz+C+WOWSqfmNTP3t+Rcg0op21aDJUS1sNT1DuoghQCXvXplT0lRK+8kximboDqAGd+UHJEP4azB/FTY5d6qzUBimpkp56SZWekq+5xbJMakj78UmBPj7e7rEP6XwCcSvKxkOOJWaBkbrJ7HyCV3B2F2jn8i0mPfyYb6qPkLdIwqUXnRWEMoVGsZcUlo+AGXnYQJ6VMDWX/B8wACtLo6lIBg8mmX3rgVd5sZJlxJ0oyZKdX06444S50KQkb9oFR/aR2YMQ3+1poZtNEHcpH80sec6T1rp8HTNVZyd3zZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09pTbho2k1JzgZlBafPT8G8KRw6TJYYiozvuSRH3x/Q=;
 b=pSbcgF3Q8iovm8ulxkXFcYdsnp4CubMYuvUbToRAwlEa/46Rx9mnf4tLYVOtw78iIhhc8GdjYEn99ZcS2WPC0sCy38fzoCSEoI68fNkPI8sEheDFfsz+bp7rQuB8NYD/iMdShXPaNVOd+itLh1/53CV510/qJC2IvrG+14VZfTROxTpGjcgx3OA5djAWtzH9qup7I53tilv0oLf6vyNFaqpAIzNheJ3ZkbXfJqqzGrsF2KEM75LFJeqbG40kwOdUldlq9xCssJSqkdgIgDp+JzrBo6Pk+/lhSyMWNR9j2KpHEIfqWutRGwkIH8nT8puSfNqyob24JL2fZHSNRtn03g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09pTbho2k1JzgZlBafPT8G8KRw6TJYYiozvuSRH3x/Q=;
 b=YSOlFISHP4djYa3U6pyIuMsSB0DFcf4zVbk8wFuiMT6S1RfGAqWKx3DXEdhrRkLwm7ra+LBKa7u73668X0qZ5KUbvwsmr4rI4Y7c0itzYPLutfw6RQ3sr5wuhU8pTbTM62p79w2KWmyVtfCy7w9yGognxTL9avG4jy3mANgfKtE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB10298.eurprd08.prod.outlook.com (2603:10a6:800:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:21:24 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 12:21:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v6 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v6 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdPGG+sbdbBbDchk+uDvmAQFi0CLa+VTyAgAABzIA=
Date: Fri, 4 Sep 2026 12:21:24 +0000
Message-ID: <73c4825c5f92e141a8fecb76bcfa9810986d67a9.camel@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
	 <20260904113404.4051341-7-sascha.bischoff@arm.com>
	 <20260904121458.000151F00A3D@smtp.kernel.org>
In-Reply-To: <20260904121458.000151F00A3D@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|VI1PR08MB10298:EE_|DU6PEPF0000B61B:EE_|DBBPR08MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: 98bdd630-581b-46b6-9ef6-08df0a7f1d71
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|11063799006|4143699003|5023799004|6133799003|3023799007|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 aRb00zBxCxNSYT0NEWbQV/4AsS4MMbClmvCEkqhUckH0KSEYVDY0AcwCse6DLmks9s5rQdzRMMk3Cv2JGScmmlDBfcpik3/4Etjw+TZm0T1JA5kl1SatviSTrVFxrCPRFnuuHpAtmgIspMSXgkOPI88HBuFzajd3q3R2p8aunsYktlUw+etUHSqLemMnozY8bE8EWGJsp9zYHxO36t5jGJytBozqI4JZWVT1jLc6gZcNa6RsEldqZQe0kvkkvYMt1uyB9RX2LM57SVD0ZkASPJHC3ZXdTKFQ8fk2NRQ+098ZFa23B1TIms3C7uXqLtoMjJWANWDZYQ6Z79jhs3AlCGUzSP6/OuLBtIugNVYBkIYZeRkFyWZwUlS1UapUIE4xko8poblwGSr3puvXYuhJW019eQm0Qav6XpBCjLjUSMpxbcle2qBtfN2h2e3Z+Iyp7x2ONRS7+5Tf8XrDZT6BIzWcS1JC/yXJMSDqcIc2grB+On6ACULyoGCOQnBh6WBspN4IA3/uWNlGBYHzYH/e/9VfuBpvUr5Tj6HJJQrT4uC7cy6RKU86JLczK43/mku4tZV9unTTizyka4wLB2O2AuIFRnqgRuVUTnLH12dNaSU5sUSGOacT6TQvim+oJerHbHGNliYFs1mobCLU7of/J1Qvzj8HhpW4nKhMpH/hf9XQeY7q/TBqAs/VVsNjbFVVTWDJzGSj2L+VOvj+Qy08XWKYfwgmbkxmr9f3tb+dSZg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(6133799003)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B09D37F25C1AA4C855DBF7394BC1A08@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 B8BrjYUurKp5pJJEav7yOxv8q9VmWwxv9bRxI+B88nTr+unqr9i2BAS99XYBq2gEQbQWlkfmzemOGMG/D8209feOn2GQe6auN8JmshTyhf32TL9tNlBHJtAx2XiefuM74VU04ieoZs1Io8EeTh9i8w6UDyME8u5uM+dpYa9f5H9V8mBTldZ4e3R7fY/iu7zoyheodA/YAPBqrX1F5lEAX+W1kAzLI8NFbzBBgax/zOaFkzuGJ1OfButOkF1VmBtgA19KqBVd/zcmThnz92+wKFuya0bAD+LVyb7R9jIo6WgRWWTXK9qJCXQJBdmkR/iiRclFZf2/4zicF5udg6LcsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10298
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	929b6775-2cdf-4cd9-b76c-08df0a7f0967
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|35042699022|36860700016|14060799003|6133799003|18002099003|22082099003|56012099006|3023799007|4143699003|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	yIca6AHaxodWTkCisK5ASSugV2PUbvproX0rpiPwdW/XUzJ9ozOcXVceTHHVpQzpWGetqrViVLYmkasUq/QJKTqnZcNaEX7cMMtwON8EJZzQFzrrqT+qDuMiqVsuF/n7lv2ikFPxRtaf+R4XsnWZbNyPAJbZ3+ZcUZct9Kr/UAkLL2FvsYeFWF92pBtwtz2zv5q9uTd/pMD6H/TJlZYWLzh8DE8l+Y6HkN0L3yiFHzV5V37I/iYp3XmoGY66OP7yWxXHXzpbv8cZrNmIFZV8ZQJrJtrlTiG1HBJ5DlUjF5pF1EF1E3ErpxtqRaN4a39lI19vQ9H1ilCGVEBCwS558K4PzffTnN5UpP6E7kIjiBSlNHFML/5Gxi+uiBjdyG2p/Twt0ab15FQ9HH4gr3qGDjWm84XW9TZvMBD2GGVxLu4IkHYHomzThRyMmf7vjyRn9tq4jGJaUDrhXfRPYDzxU9QlUyNvsZuvvgaTKmmbstkyYavrTnO7kGs8UQxKSNmYdn2wICG9S8sZJZyGytC7G3SfPGgByrB08KFcAD5czj/jtrtFo7mACJ3EaSWe2BKKQla6XZ+tHb/DagTI9PtKLFfKEHbDn6ztw63hhVPPzUwBoEvr8o9L3UlbW0B39R3uMy4tk/s1zBV4twM3LWXfY0gImZ5yVgtmxRcCzyOfAhc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(35042699022)(36860700016)(14060799003)(6133799003)(18002099003)(22082099003)(56012099006)(3023799007)(4143699003)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QiZdknTVfwLfByIEInxlrWP3Pw6z/POuGabdaaXy5An+zwAUBK/7rzUV1HHf7G/B1pUStVoJMAnoZGwGvAKO5JVDSRSszD4L11xvh6WzcNTuniA4ItVTJPGRfWREGCuYNKdyE6D2Fvc5HoFs2PztYN9X+j9S1mP/Ew91wVAV4sjXpN/u+PA95Gsh7p5nMdAjJWfXAlC3U5+9xxbtNaYjzoL7MQ62hoqyQGeDqm6RC6cax/xFzodjaNxy30f5G0z7oBr9wf7hZBfzTumC4lls5lg8a+qVqfUOq5BNDCtr7rjwfXnOIt8OAQ7YqY4gUonGeQNazj0DcthIKwMLMOvNLhVid/M0262nGumV34+ztechaDjKhrEtO+2VQRzZF1UiSRvr76/+MPkoZn8Y9ngTtU6bPqBDz3gqzrbkXwxpTC0F/4aaqQ+Zrn0Le6kdHu3Z
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 12:21:57.9958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bdd630-581b-46b6-9ef6-08df0a7f1d71
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6105

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDEyOjE0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIE1pc3NpbmcgQ29udGV4dCBTeW5jaHJvbml6
YXRpb24gRXZlbnQgKGlzYikgYWZ0ZXIgd3JpdGluZyB0bw0KPiBJQ0NfQ1IwX0VMMSBhbmQgb3Ro
ZXIgSUNDXypfRUwxIHJlZ2lzdGVycy4NCj4gLS0NCj4gDQo+IGNvbW1pdCAzNjFjZGNiZmZmNGJj
MzdhZDQ4ODY5MzIxZjYzM2MxNzYzNjliOGQ2DQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxT
YXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IGFybTY0L3N5c3JlZzogVXBkYXRlIElDQ19D
UjBfRUwxIHdpdGggTElOSyBhbmQgTElOS19JRExFIGZpZWxkcw0KPiANCj4gVGhpcyBjb21taXQg
YWRkcyB0aGUgbWlzc2luZyBMSU5LIGFuZCBMSU5LX0lETEUgZmllbGRzIHRvIHRoZQ0KPiBJQ0Nf
Q1IwX0VMMSByZWdpc3RlciBkZWZpbml0aW9uIGluIHRoZSBhcm02NCBzeXNyZWcgZ2VuZXJhdG9y
Lg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC90b29scy9zeXNyZWcgYi9hcmNoL2Fy
bTY0L3Rvb2xzL3N5c3JlZw0KPiA+IGluZGV4IDk0YmYwNjVjOGFjNzEuLmUyZDM3ZWUyMjFiODQg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC90b29scy9zeXNyZWcNCj4gPiArKysgYi9hcmNo
L2FybTY0L3Rvb2xzL3N5c3JlZw0KPiA+IEBAIC0zNzYxLDcgKzM3NjEsOSBAQA0KPiA+IFN5c3Jl
ZwlJQ0NfQ1IwX0VMMQkzCTEJMTIJMAkxDQo+ID4gwqBSZXMwCTYzOjM5DQo+ID4gwqBGaWVsZAkz
OAlQSUQNCj4gPiDCoEZpZWxkCTM3OjMyCUlQUFQNCj4gPiAtUmVzMAkzMToxDQo+ID4gK1JlczAJ
MzE6Mw0KPiA+ICtGaWVsZAkyCUxJTktfSURMRQ0KPiA+ICtGaWVsZAkxCUxJTksNCj4gPiDCoEZp
ZWxkCTAJRU4NCj4gPiDCoEVuZFN5c3JlZw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlz
IGlzbid0IGEgYnVnIGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCwgYnV0IHdoaWxlIGxvb2tpbmcg
YXQNCj4gSUNDX0NSMF9FTDEsIGl0IGFwcGVhcnMgdGhlcmUgbWlnaHQgYmUgYSBwcmUtZXhpc3Rp
bmcgbWlzc2luZyBDb250ZXh0DQo+IFN5bmNocm9uaXphdGlvbiBFdmVudCAoaXNiKSB3aGVuIHdy
aXRpbmcgdG8gdGhpcyByZWdpc3RlciBlbHNld2hlcmUNCj4gaW4NCj4gdGhlIHRyZWUuDQo+IA0K
PiBJbiBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jLCBnaWN2NV9jcHVfZW5hYmxlX2ludGVy
cnVwdHMoKSB3cml0ZXMNCj4gdG8NCj4gU1lTX0lDQ19DUjBfRUwxIHRvIGVuYWJsZSBpbnRlcnJ1
cHRzIGJ1dCByZXR1cm5zIHdpdGhvdXQgYW4gaXNiKCk6DQo+IA0KPiDCoMKgwqAgY3IwID0gRklF
TERfUFJFUChJQ0NfQ1IwX0VMMV9FTiwgMSk7DQo+IMKgwqDCoCB3cml0ZV9zeXNyZWdfcyhjcjAs
IFNZU19JQ0NfQ1IwX0VMMSk7DQo+IH0NCj4gDQo+IFRoZSBzYW1lIHBhdHRlcm4gZXhpc3RzIGlu
IHRoZSBzZWxmdGVzdHMNCj4gKHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL2Fy
bTY0L2dpY192NS5oKSBmb3IgYm90aA0KPiBlbmFibGluZyBhbmQNCj4gZGlzYWJsaW5nOg0KPiAN
Cj4gZ2ljdjVfY3B1X2Rpc2FibGVfaW50ZXJydXB0cygpDQo+IC4uLg0KPiDCoMKgwqAgY3IwID0g
RklFTERfUFJFUChJQ0NfQ1IwX0VMMV9FTiwgMCk7DQo+IMKgwqDCoCB3cml0ZV9zeXNyZWdfcyhj
cjAsIFNZU19JQ0NfQ1IwX0VMMSk7DQo+IH0NCj4gDQo+IEFyY2hpdGVjdHVyYWwgZ3VpZGVsaW5l
cyBtYW5kYXRlIHRoYXQgd3JpdGVzIHRvIG1vc3QgSUNDXypfRUwxDQo+IHJlZ2lzdGVycw0KPiBy
ZXF1aXJlIGFuIGlzYigpIHRvIGJlIHZpc2libGUgdG8gc3Vic2VxdWVudCBpbnN0cnVjdGlvbnMu
IFdpdGhvdXQNCj4gdGhpcywNCj4gY291bGQgdGhlIENQVSBwcm9jZWVkIHVuZGVyIGEgc3RhbGUg
aW50ZXJydXB0IGNvbmZpZ3VyYXRpb24sDQo+IHBvdGVudGlhbGx5DQo+IG1pc3NpbmcgaW50ZXJy
dXB0cz8NCj4gDQoNCk5vLCBvbmUgZG9lcyBub3QgbmVlZCBhbiBJU0IgYWZ0ZXIgZXZlcnkgSUND
IHJlZ2lzdGVyIHdyaXRlLiBUaGF0J3MNCm5vbnNlbnNlLg0KDQpUaGFua3MsDQpTYXNjaGENCg==
