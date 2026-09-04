Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013001.outbound.protection.outlook.com [40.107.159.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CF455177;
	Fri,  4 Sep 2026 10:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516609; cv=fail; b=fdtllIJeTWToQ3argKfpOZhbzmVXvRpe+zoJWRJUW9wEbx/QoeA3G1q8dTbtcMmg8I5bG1r/B9LfQpz5C7LZ4uIGbpWXq6ul4hpUue8HaX6Mv0MX2huqIdzATMzEbuzPiUfrQNO5MbBet508TirUYpNDiR5kh+a8ve94kJBzioU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516609; c=relaxed/simple;
	bh=mrur3t/WfYtnBkT4elfCXsqRZ7pVyX0BSLGTedn2G8Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=egs2gmntTpSNAG++i76DdeTxkKPjN3uIr/bgJzI0wWU+kJh7As213WVSgAfQxyWSWLOwVgSM8Aqaiw1/1I8VWpigpgyu5OT4ne2z8sBr6FSeNMEt0clI7cxEelrbmxFxeSqwAP0Q0doL8p0kzI3cXIdlwQ+2GvIoLVMwj1NCAk4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TQGSDK7/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TQGSDK7/; arc=fail smtp.client-ip=40.107.159.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TQGSDK7/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TQGSDK7/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BRvpTwA8tuob7/A4wztsP4C4RXXXLGhB7FlFLnWaWVYpTkj6e2bkczEYACIX+Wj7FVJryd+Dt+KIt6BQ4NBRPI0cEugGvFuer13Jf7/JWj0MUXTWCn5XEqJZ5KGvkybvsms2FXKs3BrdGpdxpIMGZXKkowKEmJB0ZhCIhTtVU0OS44dTIImJBO1YDmSUo1tOEP3TJqZbRgru994/oR9yoX4bmHp26qQTlY89k5+wNjkvZGrAm3KAmz4Oz+/PebrFMGbBUn2I8KLiwReYzGA32J/O+o3EHbTJyB9JowWJ147U01IrbqGc9gx3eBwdIcRqht+9fkSm6mArak/tX7ihhg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrur3t/WfYtnBkT4elfCXsqRZ7pVyX0BSLGTedn2G8Q=;
 b=LnZ7gGY/kMPJfCng/PSio/a0nLWlzJA7Kx8mK0IE4Bko1LCHL/MX9zuv0qhGsuCX5zjAIxFmoLoaQke43wYI1yWSP4ZNsv4dPSh5X/5vBUDYSOR0UcM9dsSdVX3z5wb9hnZCUvLxNRY+0vV3TZqIGU9RXyDvpTIe9HT5VeICqZzdDzIPONGQbW8vMy+0GucAbxHTjvUVo8ya/LAxRhMCjs/urQm8q5kzYrObmlevwlkO/vpoINVnqDpk9GMSPmv0dAsizAlbKJCwzELgcFSdsAZP7cTR1PmAUv+z7H+bLTUE0uhHsSmg3QXfpYoqvlHG4gcwyMu1S8Vnjcr40eTnvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrur3t/WfYtnBkT4elfCXsqRZ7pVyX0BSLGTedn2G8Q=;
 b=TQGSDK7/Ut5fMPPomdIpRuVSKF6Rq5v75ypHmO88UDchkwNko5Gv7c6idTYVUTI35BCbpBaG+ngR8G9irWSnkt0F2Rw3sz5INKQZXZJbAFDQg4UJDVJJguAOGZ8+69beVX9VCej9V/M11Ys6KaQkBBpZ85V8JZi7TsWscDSd+5E=
Received: from AS4P250CA0012.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::18)
 by AS4PR08MB7501.eurprd08.prod.outlook.com (2603:10a6:20b:4e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:09:57 +0000
Received: from AM4PEPF00027A64.eurprd04.prod.outlook.com
 (2603:10a6:20b:5df:cafe::8b) by AS4P250CA0012.outlook.office365.com
 (2603:10a6:20b:5df::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:09:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A64.mail.protection.outlook.com (10.167.16.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:09:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vk0JcPb03jn//90JZ7lJoo5scN82TUKXr/OuKoOykWQeLVDxf68eD5QJ1naNaiPaslBITMXgFFofu7htiikViO6FoTlTBZTIcYhcZ+VXJCZDlKTu/Nh4mR12mqbGrIbqsmZvJlTtFbjgfGamRShiziG/j3P29jyIDmFaeTp6M3zRGuKmZHl6zmLdmYhaW/zajResr89+WsvK9BhOMwhUudGZeCmNo057rEV1nQFIADPtHjWbZyJihzHDJyghzBKmltHknY2FPo53jcIP0vMu/muaDoUy3isLqmBKHY4NjSukSxTRo+8iX7NRW0d/UqQ8JVE1VBYZcS9ZF002YtuB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrur3t/WfYtnBkT4elfCXsqRZ7pVyX0BSLGTedn2G8Q=;
 b=q+Ysr0KDoONRDlFCNnhupPhCx+cGtCb75wYDqoSa9D0F+ChTbn8nrxKuTcK4kKxZUmrUrlxbUK7XtzeQefIBLm5E/2I3Iu+jwJM6fagUznW46GIlV3/McWfDUl+HQ8opUTNMKuzoItGh5iQBPFLU7RYFgnXx7dt2FP+P+Vpe+WoUBLkwEHItNnDJjWlQ6Gr+9wBazuNcg9iQfRVTOATRCiznBkLQPelkwAe5bCTTSFTgD9p7pvKpyfeS6FpygPp8j9am2IlRHcJKGZBQk68DNkqtS4PghKb3Bl2uFW6UpUstfSMPQJePZHjUsl5wq6fNw/OppVo61J2ECBz7LaKlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrur3t/WfYtnBkT4elfCXsqRZ7pVyX0BSLGTedn2G8Q=;
 b=TQGSDK7/Ut5fMPPomdIpRuVSKF6Rq5v75ypHmO88UDchkwNko5Gv7c6idTYVUTI35BCbpBaG+ngR8G9irWSnkt0F2Rw3sz5INKQZXZJbAFDQg4UJDVJJguAOGZ8+69beVX9VCej9V/M11Ys6KaQkBBpZ85V8JZi7TsWscDSd+5E=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DBBPR08MB10794.eurprd08.prod.outlook.com (2603:10a6:10:53d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:09:20 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:09:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v5 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdJmBI31WfVMcIMUGOQ4jbbcYug7aSzZqAgCuQigA=
Date: Fri, 4 Sep 2026 10:09:19 +0000
Message-ID: <a1dba387e5ff35c93ba2c3f745e9d35959cd3b9c.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-38-sascha.bischoff@arm.com>
	 <20260807165249.701EE1F000E9@smtp.kernel.org>
In-Reply-To: <20260807165249.701EE1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DBBPR08MB10794:EE_|AM4PEPF00027A64:EE_|AS4PR08MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: ad7af9b6-ac77-49e4-b7e9-08df0a6cabd7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|56012099006|10067099003|11063799006|4143699003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Bvo6C/4FCieHCYHPky6a0jnCDq8jAhRvMMfCMaEhUlwLB5xFAD6mA9fnXtDQpuaswyVBWX/0LIOemLmAELvlSsdylHfa5dKtyo45/TsAFm+x3yFKVQ/ZEGNlscaBjaK+WTkqrt0opqFXobJGRJNi6ly0hNGTuUedwTRLzploy7jP68/sCQ7kHL49J6wqN9/b9N+uUMy+U43SlzCdEPAzQQVUBv84UePyK+tQAHAYHbsz9/pAhjYNl3A/0xWorUBqxxs1OZrCRnSVB3i9MIUHK5DWPc7kjimJ+ctH4hg2oEU5kvr43ysFXDnaq7SnPBNOrxDBFFwgxwq/CjjRad4/xH4L7liLBmfOxN79W5m6FS9nfM4Uvk9jwb9c9WQju9ga5Zrp7sgomRSOlPsnsChhyKwb0XsOeMmj51TOlP2ymK1EmbWk1TQGIzLQ4WVEDG+F+RBQpWdchyVVAZWav+dmtPOaMAYzTZjvmnlluuMOAp2jQQN5eg0pqpYGVaRu2s27IXRiKy3+8UcJ4voZ0ID8+pAM8IKIhxsm7n2htyQ3NLg9/1KdA/CY2Gji+uPQmJ6MIFIhrH5q/CI1ghScBLDrpffHQtOVj+SKnrWM9C0+uJnxX8U9h3Ji8U2QbTx661HMIFkwo6gvQRo7zJZBhwPJrTs9lT0bcIX/AZYb06umB9Kt9VYh0twxjYBg6IxjOh4n/PspgUUYeOYnrmHHB0mSLvsnQ3cmuC72g/+tTCD0FMg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0FAFAEBE2659E49A7973EF635DD2A67@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bO1kBCOGRL93q04JCM3YVhPhNBmOTIl24az4Y6oDMWLrQdOK1I4CGg2AWTh3dSo1Fw60YuE2ryLIFsHULNs9RKkHoNwT8wDZTjyPknx5YA/nfb5URspUy2MB9bA2GRnK5kU3gxIxxUpToYSgbe8aDpMr+Bz78ZFIYFlI5QwbDEUUBKSUXgA9n2WyL+LDHeihDByR9o9h3v3gBGa4HgY7JCQUHjnzBfnAEqnoF56XnxANdN3eoBBulM9r9n2NI9RfUGjv1Z/NRX0hRSMOoNWhEFWtdYfJ2yLKnq77yMXvWLZ/1y1rhG8FAU2K0LYk+oaW3OWNeo1hq4hPKCytCwPukQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10794
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	663009ba-c0a9-4d7e-0667-08df0a6c95db
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|35042699022|1800799024|14060799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RzoBwqUSo+172/dYBdg8Uo750K7NdjzeTFc7KZTWfgyM2p+QNzJ62rN4XXH60qzRx1wlHRdAxNsZmQ0zUeUAUD8lIu2N0Nw5L8n8GiVSF2fjVK4esAmxTUerHJE5VUZE5c1LOQVL5m+oA1vfX1FlVejt99Ozw726nNhJxV5GXGgRkF5ZIo82p/MxV3lm9Us2JBW5iU56Brq4oNsBtz59e0hjxRZDeE0xub7PbbGIzSjcc0oeG0glRYWNOlE2oOBrHovEO0uRj7uB7qmqjdmLtp7poiyLX3FdwHRsHE5tM/TR5nGUQRHrgDB0zpVM1NELmVfUSkn+HRRHkRegR34oFC2pymI3T7RDpiXMYRLayZDCBB50n5SDBwe0KD4qusXd3TJXzHgEInHnY/AHHQn7iaATD6OdtuYW1YrNirClSb2G4no1AStpskeXc4gcdaz7wiymWF/1ct6nfCxgvLSPE7OnkJWNYuUahvZdwKPAfJk8dXwfmlxzIc+I7/bJB0UOHUshBxWPYCJMlUze/X46208AVUn4Q8c0aByxObYyF4lqSKbgrQ/FRJmmrh9rO3EE3S2tCLSxhYJSX9nbV95gR1oMbuMVWlmcoooofW3iArwnWRKv9DzWof/O7vmDup5DhHHgd87oL4c925coRB5ZCPyGY/PMFiQTu97HrMCo0qo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ucPxy7G6RNe0JCJgPP9nErDfzgp1hsKGfC21vDzvGahUpiNTPDZNpzGZeHU3UP8i4DF2z3vnc90beC4ZL8sai4uRx6isGdyTKel87wv1pGVhmgBNo7jw0dsVJuH8KQGVw4beoP3tgLV3UvYkT8zj8e/TvfdzoJaXjJ11CmZD4Xz3Ah/Bnd2FZSxmXzi27b8BjeW12jRChIYaryipUKncksQQvAqgULJmtZOQNvbgp+vNDe4ayrd7aYGg1971jJri2xtNXlA7ymlkjqSS2O4Nqk6+sOzan5qrOX/Czfttbe7A4s4h7Hei5fJmcdyZsgO9Xbd3vJIVYQ5/ScOQCdB+QUV/sqPLMTw4FX+RBZG2hee+aHQ+wPxCuG4TQa6ZUAMJTnKChTtUkEEBn1fAgt9BZ+bkeLFgtoLcKCpcNhCd+OLX1+uXbitFgpv/kXpMkkUM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:09:56.4774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7af9b6-ac77-49e4-b7e9-08df0a6cabd7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7501

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjUyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTG93
XSBNaXNzaW5nIGluZGVudGF0aW9uIGZvciB0aGUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJTX1JF
R1MNCj4gZ3JvdXAgYnJlYWtzIHRoZSBkb2N1bWVudCdzIGxpc3Qgc3RydWN0dXJlLg0KPiAtLQ0K
PiANCj4gLS0tIFBhdGNoIFszN106IFtQQVRDSCB2NSAzNy80OV0gRG9jdW1lbnRhdGlvbjogS1ZN
OiBBZGQNCj4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJTX1JFR1MgdG8gVkdJQ3Y1IGRvY3MgLS0t
DQo+IGNvbW1pdCBlNWRmZmM0NmVkOWM1Y2RhZWNkYmI0OTk5MTM3NGQ4Zjk5YmZhMTMyDQo+IEF1
dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IERv
Y3VtZW50YXRpb246IEtWTTogQWRkIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTIHRvIFZH
SUN2NSBkb2NzDQo+IA0KPiBUaGlzIGNvbW1pdCBkb2N1bWVudHMgdGhlIEtWTV9ERVZfQVJNX1ZH
SUNfR1JQX0lSU19SRUdTIGF0dHJpYnV0ZQ0KPiBncm91cCB1c2VkDQo+IHRvIHJlYWQgYW5kIHdy
aXRlIHRoZSB2aXJ0dWFsIElSUydzIE1NSU8gcmVnaXN0ZXIgc3RhdGUuIEl0IHByb3ZpZGVzDQo+
IGENCj4gR0lDdjUtc3BlY2lmaWMgaW50ZXJmYWNlIHVzaW5nIElSUyB0ZXJtaW5vbG9neS4NCj4g
DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdp
Yy12NS5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12
NS5yc3QNCj4gPiBpbmRleCA3ZTQxZDY2OTk1MzhmLi42ZGQzZmY1NTViYTAyIDEwMDY0NA0KPiA+
IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4g
PiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+
ID4gQEAgLTE0OSwzICsxNDksNTAgQEAgR3JvdXBzOg0KPiA+IMKgwqDCoMKgIC1FQlVTWcKgwqAg
VkNQVSBpcyBydW5uaW5nLCBvciB3cml0ZSBhdHRlbXB0ZWQgYWZ0ZXIgYSBWQ1BVIGhhcw0KPiA+
IHJ1bg0KPiA+IMKgwqDCoMKgIC1FSU5WQUzCoCBJbnZhbGlkIG1waWRyIG9yIHJlZ2lzdGVyIHZh
bHVlIHN1cHBsaWVkDQo+ID4gwqDCoMKgwqAgPT09PT09PcKgDQo+ID4gPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+ICsNCj4g
PiArDQo+ID4gK0tWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTDQo+IA0KPiBbU2V2ZXJpdHk6
IExvd10NCj4gVGhpcyBpc24ndCBhIGJ1ZywgYnV0IGRvZXMgdGhpcyBncm91cCBuYW1lIG5lZWQg
dG8gYmUgaW5kZW50ZWQgYnkgdHdvDQo+IHNwYWNlcz8NCj4gDQo+IEJlaW5nIGZsdXNoIGxlZnQg
YnJlYWtzIHRoZSBsaXN0IHN0cnVjdHVyZSB1bmRlciB0aGUgIkdyb3VwczoiDQo+IHNlY3Rpb24u
IFRoaXMNCj4gd2lsbCBjYXVzZSB0aGUgZW50cnkgdG8gYmUgcmVuZGVyZWQgYXMgYSB0b3AtbGV2
ZWwgcGFyYWdyYXBoIHJhdGhlcg0KPiB0aGFuIGENCj4gbGlzdCBpdGVtIGluIHRoZSBnZW5lcmF0
ZWQgSFRNTCBkb2N1bWVudGF0aW9uLg0KDQpUaGlzIHdhcyBhIG1pc3Rha2UuIEkgaGF2ZSBmaXhl
ZCB0aGUgaW5kZW50YXRpb24uDQoNCj4gDQo+ID4gK8KgwqDCoCBBdHRyaWJ1dGVzOg0KPiANCg0K
VGhhbmtzLA0KU2FzY2hhDQo=
