Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013018.outbound.protection.outlook.com [40.107.162.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D939D3EB;
	Fri,  4 Sep 2026 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515290; cv=fail; b=k0oZ940f2J9S48BYHvvBYeIIfJwBSVZbO+wPig4AwV4rqop/+pDymDjbGTfVQREDzJIG7+scl13vo7C5x5U2EB6AK8zBAlRCfvCeVr+tG5aggwYpzH/7TLtLxL3Zj5c7yRQ0sRT8HhmojB1PP1kUm9dPtbqxwR6l97qQOSZUmqk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515290; c=relaxed/simple;
	bh=zWJruxG/RinDHyo61DBu30IW5TkQym2eNjsyUXQA0GA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=THpxgZCoMVAtgfUG/yp0lS1+5TmwaT/eQ6xeGh2EkaFrjVmfDt1VMntdCDB/zMTEYvP2fq8+AQxtK7LKNkGxLVdYvxtUnT3p9aITvhkKogcvbmWjdGwR8yqd8C8WLLWMQ+Eozfwjv84D0dF9QCd19rwDovNVigvvlmu/Kr9LiNU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fr3wqZP5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fr3wqZP5; arc=fail smtp.client-ip=40.107.162.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fr3wqZP5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fr3wqZP5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BIaoFs+echMY8/jSXpn7um8BD2CDEJlRDPd5SnVVyLvB0UTlO5TF54yYlztH+0gvSKT5ZiA2x2CwvPkBII/SDsgEsWUscXu9a2Zfh6Nmrn6TUzMfGF83gEhF3Ji2CH/FOd52WxO2wUtBY20BJV3IrUtsTCst/LuiPpfygJwiV1BaoD8tMmy12MnoYiYvEoFlSxT9TMUXfmEK/ZH2PK3f/NDlOHmEGJ0RvvDDsVPKP3L/El46P4Ag4re4lceu/3n1KqrHRAVwVWiU5foGJfvMqwLMWKbRDy85Uz+JfzR4C6zP9Th4rXVIDczPqo6nHeGG6daAfkazvIzMfAy7noSKJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWJruxG/RinDHyo61DBu30IW5TkQym2eNjsyUXQA0GA=;
 b=CRupXtE9AWOocKYQZQvoRlIwoPSMtcq/n1pwt6sPOzusRU4fCyjQ7xcEDUfzN30zEp68heg6aSbdf7+p3aWsUvHCAwo2ImjUAWEue3TVlbTrReVtN4G16J1ZMtXX3oPFRU0sjuwo4Beu9mjOIpvo1BjHUaoY2Yd4xvQwYCsiFyulcuZ2pjQwHK9zu/1GwGQYPOPlDIgM3LcDEwm7ZynnmiI7d9KNoIbPxE9YYzQhDYx0uWQ1NUb0mtU4BVftabASzMMarb+u6LowtS/JHD6di7bLTB9lBDI7FFIEoNJHZbRSpLymblqAry9kI/Bv1D0/1VOMDkOqnAJo+VYHZBJ8Pw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWJruxG/RinDHyo61DBu30IW5TkQym2eNjsyUXQA0GA=;
 b=fr3wqZP50qw6R6PdNrbGXy0PV2fnWVbQl1LxOqT69Xyrl5kPsqGnKrdVZboCdLl+J/cGwbQzRSR2cKMAfc2dzc0ab+nlHdZgNTuLBcP8ZhbyMa6WBC7mRwyTk+zCudOCD5jx/WwdFov+ooR7n3APbtElC2zaUHUc9xcGU5mMOmc=
Received: from VIUP296CA0072.AUTP296.PROD.OUTLOOK.COM (2603:10a6:800:349::13)
 by DB4PR08MB8077.eurprd08.prod.outlook.com (2603:10a6:10:387::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:48:02 +0000
Received: from ZR1PEPF0000E6AE.eurprd05.prod.outlook.com
 (2603:10a6:800:349:cafe::9b) by VIUP296CA0072.outlook.office365.com
 (2603:10a6:800:349::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 09:48:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E6AE.mail.protection.outlook.com (10.167.241.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:48:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UayXR0HvoN09q3DgjJ16FXf9tUR35jJe9QRzPk4GB5I4Z8btTQECy//yMwdhHa5f55poA4ZnCU7UmSLUTQn8r2nlBUsXiL0PY4QgOS5xFZ8w8fmPLB4Jn1XjLnJ+mhfs06hy8WQQ1Z1FGo4q96kgTs3dLXD5jdbqfq8xQPOqtnV/xcMHcRH2teUOjb0xScxzdtHQC4FutxiaRo0Y5q8o6mJx5MCQ/JgcaKAu56pCOdEADOF/bzE6NV3+htVr27R56V15egDpF9UPMd1pXvZdsSYeHU+vu+ZweLhi6n+mnppI/8tD6yXi1snp3KvmqcMKYPdf7g+dSoZmVgwo++rnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWJruxG/RinDHyo61DBu30IW5TkQym2eNjsyUXQA0GA=;
 b=ijNASrzIAl3dxmn/xZyoM0G9gjMrpA6Gbt6/v3s4sDkYZP5sljzMP+hx+HAtn3Kq0XCbfthBQsgGxzHZRVCZ7OimkXfREa6t9b+py1YsKEOK1md3d9gVs+pSr4AayQ0rNepsjjH1H1J2AMZjve+pdZV9HBD3baOs6DpeD8JQVbolS1GUItOdpdmhLbQi3hM4dDZb+amAN2x9fqPnlY757J3KVOmneIOtdtGft7qOdDBfIbd4K/SJs4U7Yf4PbuxMfNN6PIdaZ8GfSxwsGyLPo5KFw++2iNkkXx1dYzHirNeastV/fD/9vO51ViZeDAVtcVZ/ryPxdSNd45c5E5IWMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWJruxG/RinDHyo61DBu30IW5TkQym2eNjsyUXQA0GA=;
 b=fr3wqZP50qw6R6PdNrbGXy0PV2fnWVbQl1LxOqT69Xyrl5kPsqGnKrdVZboCdLl+J/cGwbQzRSR2cKMAfc2dzc0ab+nlHdZgNTuLBcP8ZhbyMa6WBC7mRwyTk+zCudOCD5jx/WwdFov+ooR7n3APbtElC2zaUHUc9xcGU5mMOmc=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by ZR6PR08MB426049.eurprd08.prod.outlook.com (2603:10a6:910:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:47:26 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:47:26 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Topic: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdJl+2LIxUaUm3KUeEZ5M8zHiUPbaSuX8AgCueiYA=
Date: Fri, 4 Sep 2026 09:47:26 +0000
Message-ID: <aeb0f70cf48c415b97f051aaa44603a06d27d697.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-30-sascha.bischoff@arm.com>
	 <20260807154051.77F6D1F00A3A@smtp.kernel.org>
In-Reply-To: <20260807154051.77F6D1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|ZR6PR08MB426049:EE_|ZR1PEPF0000E6AE:EE_|DB4PR08MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e5eb754-f279-4918-79e0-08df0a699c3b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|6133799003|18002099003|22082099003|38070700021|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 NCXA4j8k0+uao1W3YduUtZmDb8X084+Djtv8a9gq06o4CVW7xch2E/vg2AT+KZXujOZQCCs8joTNB4jzk7xgOP0pahb58/jqyamHkJgfETq/cKlUYs1QOwgkpBaL52Zr31mNnthy+gwp16XBOMiqAujEwyK0qb7EncZXCjskRhqzAyA+Jd0+lQswyWo2PyP/JeGv8RHF5ETMhH4qlvKat5wGKiHQ3cwMHOb9C4tSPW/TfVLqC0jeml9Nh6w9d35uO30OgSSs+9YadprxXNwrCD0Hi9hfowhPuhMjkLjRgOGASWWjn0FBM1f7meQXD7I1Y+DGWQM8b3A3xaciSsqDpaLjBG7Ul3oXOdtXEPZ4NLg0q7HTOCKmnwDgpoLLG3v3bVodJI7x5D6AeS9Zjk5BR4rykAKmLSJUlKTEfsFeW/U0RksIXtap3nlqVUNNW8XFrDhnZR+6prXHgjEAU/LG8rDJkW2YgzOGDj3voMc712K0RbNvj3Fb1Fxq7dH9BWyLEWLdQ1izSSAWxJFkFeYgd5s0ThvfoluiBquh69vWdAek/f1j19db+nqBvDvQ0fFZRt0sTXds3Y7mdgf7L5rXG8gbLDTBH5LjRn8DpmsBnr0/knyJisSUWCoTV9u1ja704rJjF4e9u4OaluDnWbk6bp1pxJOWR1pma0vl1iPkufirx7Q5V4mHSKMdcmN8fWWqMTPHJgDEnI4+qjshfnTwtleQ1L/Wz8Py3S0pCxMdLGo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(6133799003)(18002099003)(22082099003)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <49B5A2C2351200498052E5CA1AEE7BE3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 vxZKw7ljlvkcaExPpydgvY+VH6gDknai6EiwJ6mfXHDeCADKxNbiEONlyU2ie0OeIF6EeFTD+JGAi4Rr2MFfT0LfRg/T2u6eu6vDe7ceAnnv41vFe2YeXyL1A86tsu4fIqWbdXCydYV4UVG4+JguwTyka41jytFCFQ/Gh2BS2v30tTBjam6jbN/jjQFmmqamLi3Vwf+olz9m+w8FLlG4tiyUqAvHyDidwtvtUBS5mmbBgpyTvxYMlUug3veauSNICtx5wOj29RWUhqkUVT1/VcCUOpCLkB1Qb75U9ZULLWBnFDL2b6DO6y0enW63+DOqMIAgSjohNpbpsIuW0Q2NCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB426049
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E6AE.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2dd7dcd5-6107-4b19-542e-08df0a698730
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|23010399003|1800799024|35042699022|36860700016|376014|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	GUawoYsskrkt5DAJQDLnMM+0jR52hzl3kvDhSzNJb+TcU84OcXhAAD+EKQFtOC9FCchqWcqmw0wWP/X1DAkVPMtqvwomz5vcAnBsMr4iWprBs6CEkjyoHjxwHKYuTAi4hkJ0nKFamxgf0SPLKuFGyCxsw75+xFuiqdNhgs/dwFUrDxpson26KTa/3xYlZrRL28qAjfIwnpD5aiQE0PPPSE6Z3A2WK1q9CL31+56gkKQ/RPeUrgT5AWu+LzARVL23nGkB2H0xxU38skoKPL7wyOdWsWajLEdVOeQ+eWVagq8ZKaBuE2ePypUIWQKK6G/gMwYDmVR/Be0dNjlM+wH8iqYuwJWY45FrVc2ns0Zvgk8TUoy1+TGP1WaoOSeCWoSAfkhDDaTpbyKkBwRaldlyqy0Oe+GEKZJWtLRO1W6NiidtugMLrg7MykKkydYvaVh52TCQVswP1YaDvG8aXJ90f0/WG5Rq/1C0XkJFrFH2eLAgVHS+hKonpSOqMP++pVoZrQJPUDcC4rmfFeJ/s8FK5sm1F5uwyvLxhH5++J23Nl9fldppYj+GSDQW+akpJ6rRVC7PjcD42lRIqdIQVWQm2KfMJWM0DmQR5aZc4K9ntZXqDRGDH3t4Z7MuqGxEn7OcFBlmIzNzgcRuDJiNykW/656Sn3ylr3dOznOmPg0okLs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(23010399003)(1800799024)(35042699022)(36860700016)(376014)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tOGaXaep+b9/wbdJ4jpEsezWR25c+/k75+YzF7Ki6FTe+vPK/HgJWM7g0BodkA6s+cbrFOz1vFSiwH8ZJRKX66NcjX+n0TUrysfQ2MypooMY5mJotiel9hDdnHtWMB9B7M4d0J7F/RVvO9TFWTo73J+t+huP9usn6pByWORTxsirhrEMSA0KVnVzlAvoxpkrkA9WxKhwVNcS5z1GVbWwg5bOt6rVlNVmnOsNA0YCdvf1qw5dk/u2Nv4kCzd0Rb/CslNliij4LX90iuEqiEjjW+u88p57DwDXC8UNOhmGvr0mHWl+KTei7uxLb1aP6t9HZkLM1y+S5DmLMFEkDgE4/5aI6/FtwrxLpRk8ZhGMC6HRgYK17O+ZJ4v4+aYyDxCnNez7zOoljwqeDxBsfAqgBcl3ksd8mLNsQZ+0X33nj6gj7KqB61DhO5J7TONfSHF2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:48:01.7372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5eb754-f279-4918-79e0-08df0a699c3b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E6AE.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8077

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjQwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gR0lDdjUgU1BJIGluamVjdGlvbiB2aWEgaXJxZmQgYnJlYWtzIEtWTV9JUlFGRF9GTEFHX1JF
U0FNUExFDQo+IGJlY2F1c2UgS1ZNIG5ldmVyIG9ic2VydmVzIHRoZSBndWVzdCdzIEVPSS4NCj4g
LS0NCj4gDQo+IC0tLSBQYXRjaCBbMjldOiBbUEFUQ0ggdjUgMjkvNDldIEtWTTogYXJtNjQ6IGdp
Yy12NTogQWRkIEdJQ3Y1IFNQSQ0KPiBpbmplY3Rpb24gdG8gaXJxZmQgLS0tDQo+IGNvbW1pdCBh
MGI2YzRkMDM2NjkzZjg2OTZiMjFhODQ4NjcwZjQwZGU3YmMzNGI3DQo+IEF1dGhvcjogU2FzY2hh
IEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdp
Yy12NTogQWRkIEdJQ3Y1IFNQSSBpbmplY3Rpb24gdG8gaXJxZmQNCj4gDQo+IFRoaXMgY29tbWl0
IHVwZGF0ZXMgdmdpY19pcnFmZF9zZXRfaXJxKCkgdG8gdHJhbnNsYXRlIGlycWNoaXAgcGlucw0K
PiBpbnRvDQo+IEdJQ3Y1IFNQSSBJbnRJRHMgYmVmb3JlIGluamVjdGlvbi4gSXQgYWxzbyB2YWxp
ZGF0ZXMgdGhlIElSUUNISVANCj4gcm91dGUgcGlucw0KPiBhZ2FpbnN0IHRoZSBHSUMgbW9kZWws
IHN1cHBvcnRpbmcgdXAgdG8gMTAyNCBTUEkgcGlucyB3aGVuIHVzaW5nDQo+IEdJQ3Y1Lg0KPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZkLmMNCj4gPiBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jDQo+ID4gaW5kZXggMTlhMTA5NDUzNmU2
YS4uZWUxYTFiMjE0ZjAzYyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtaXJxZmQuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jDQo+
ID4gQEAgLTE5LDkgKzE5LDE0IEBAIHN0YXRpYyBpbnQgdmdpY19pcnFmZF9zZXRfaXJxKHN0cnVj
dA0KPiA+IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUsDQo+ID4gwqAJCQlzdHJ1Y3Qg
a3ZtICprdm0sIGludCBpcnFfc291cmNlX2lkLA0KPiA+IMKgCQkJaW50IGxldmVsLCBib29sIGxp
bmVfc3RhdHVzKQ0KPiA+IMKgew0KPiA+IC0JdW5zaWduZWQgaW50IHNwaV9pZCA9IGUtPmlycWNo
aXAucGluICsNCj4gPiBWR0lDX05SX1BSSVZBVEVfSVJRUzsNCj4gPiArCXVuc2lnbmVkIGludCBz
cGlfaWQ7DQo+ID4gwqAJaW50IHJldDsNCj4gPiDCoA0KPiA+ICsJaWYgKGt2bS0+YXJjaC52Z2lj
LnZnaWNfbW9kZWwgPT0gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1KQ0KPiA+ICsJCXNwaV9pZCA9
IHZnaWNfdjVfbWFrZV9zcGkoZS0+aXJxY2hpcC5waW4pOw0KPiANCj4gW1NldmVyaXR5OiBIaWdo
XQ0KPiBEb2VzIGVuYWJsaW5nIGlycWZkIGluamVjdGlvbiBmb3IgR0lDdjUgU1BJcyBoZXJlIGJy
ZWFrIHRoZQ0KPiBLVk1fSVJRRkRfRkxBR19SRVNBTVBMRSBjb250cmFjdD8NCj4gDQo+IElmIHVz
ZXJzcGFjZSBjb25maWd1cmVzIGFuIGlycWZkIHdpdGggS1ZNX0lSUUZEX0ZMQUdfUkVTQU1QTEUg
Zm9yIGENCj4gR0lDdjUgU1BJLCBLVk0gaW5qZWN0cyB0aGUgaW50ZXJydXB0IGludG8gdGhlIGhh
cmR3YXJlIFZpcnR1YWwNCj4gRG9tYWluLA0KPiBhbmQgdGhlIGd1ZXN0J3MgRU9JIGlzIGhhbmRs
ZWQgZGlyZWN0bHkgYnkgdGhlIEdJQ3Y1IGhhcmR3YXJlLg0KPiANCj4gU2luY2UgS1ZNIGRvZXMg
bm90IHRyYWNrIHRoZSBpbi1mbGlnaHQgc3RhdGUgb2YgR0lDdjUgU1BJcyB2aWEgTGlzdA0KPiBS
ZWdpc3RlcnMsIGRvZXMgdGhlIEVPSSBmYWlsIHRvIHRyYXAgdG8gdGhlIGh5cGVydmlzb3I/DQo+
IA0KPiBXaXRob3V0IEtWTSBvYnNlcnZpbmcgdGhlIGd1ZXN0J3MgRU9JLCBpdCBzZWVtcyBLVk0g
d2lsbCBuZXZlciBjYWxsDQo+IGt2bV9ub3RpZnlfYWNrZWRfaXJxKCkgYW5kIHRoZSByZXNhbXBs
ZXIgZXZlbnRmZCB3aWxsIG5ldmVyIGJlDQo+IHNpZ25hbGVkLg0KPiANCj4gQ291bGQgdGhpcyBj
YXVzZSBwYXNzdGhyb3VnaCBkZXZpY2VzIHVzaW5nIGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHRz
DQo+IG1hcHBlZA0KPiB0byBHSUN2NSBTUElzIHRvIHNpbGVudGx5IGhhbmcgYWZ0ZXIgdGhlIGZp
cnN0IGludGVycnVwdCBiZWNhdXNlIHRoZQ0KPiBwaHlzaWNhbCBpbnRlcnJ1cHQgaXMgbmV2ZXIg
dW5tYXNrZWQ/DQoNClRoaXMgaXMgaW5kZWVkIGFuIGlzc3VlIHdpdGggdGhlIGN1cnJlbnQgcGF0
Y2ggc2V0IC0gdGhlcmUgaXMgbm8NCnN1cHBvcnQgZm9yIEtWTV9JUlFGRF9GTEFHX1JFU0FNUExF
IGFzIHdlIGRvbid0IHRyYWNrIHRoZSBzdGF0ZSBvZiBpbi0NCmZsaWdodCBpbnRlcnJ1cHRzLiBU
aGUgb3JpZ2luYWwgdmVyc2lvbiBvZiB0aGlzIHNlcmllcyBoYWQgc3VwcG9ydCwgYnV0DQppdCB3
YXMgZGlzY292ZXJlZCB0aGF0IHRoaXMgd2FzIGJyb2tlbi4gSGVuY2UsIHRoZSBkZWNpc2lvbiB3
YXMgbWFkZSB0bw0KZHJvcCB0aGlzIHN1cHBvcnQgZm9yIHRoZSB0aW1lIGJlaW5nLg0KDQo+IA0K
PiBbIC4uLiBdDQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
