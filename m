Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013027.outbound.protection.outlook.com [40.107.162.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0030423160;
	Fri,  4 Sep 2026 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511711; cv=fail; b=HZjr9GzfNPQ5MThMdNV4m+N9Xl34TqTxX7gFhw4yvvjAz7Z7i3RksxlbhXjlwtN8r93wKe7y/d3VyBqFDJDwh4boMUuv+CtQ2HBgUqPyavhkntx9HI+FUTwjkFR/0vhrGsh3JJbgqxqAtuiMsPmC7RmQm9iFEGxNBNq16MYCvUs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511711; c=relaxed/simple;
	bh=UcWaqpTM8VDNdi6BYpa8R1tuoObFdE3QgVcgwoHXp7k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EqXU/C1Fce4bgfVxf1deLS0fk61hwvaclfWgfvWCM4Sbj6gNiqYQrbx+csKonc2KL6g/aptLva8lZATNvwFmdWWeEATNOrHrMZTC3Ux/CCmRkdbAxE+g798FT7Q2pq/nbZHUt2NWsRuZhCgcTOvFVBQHiq6SVVtBRLFg54mE/IU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jw4egqnZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jw4egqnZ; arc=fail smtp.client-ip=40.107.162.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jw4egqnZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jw4egqnZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tbB5Z67TB+ICbAFPOdwzrhdJBefL7DZMs4gld3HlnHJCsDVhsnfN/0mSeD4Myj/vX1tJJlACGyzhXVv1BNwMY62EVk2hY3gMUrVmKSMhsKd/2yB29EF37/6h87Yt0LJ6KeENhEtgDo8xh8LKhaUZNkMDtc660BR3o3mOSxYFenrI657lqtnjNIA8dwousjVjY1rPvEcjOYZKr3Ik6ZjB8/ypRTf0Kg4pQtGOlbKo6QAo5d6Z3pqm0qmq5u4PE1BQH3z/jAYqcaIYBX2emziE0OzC1KULrdtCAKVhK7UkT55aA/7xjmorERnYs+/z9SBSmk4JPN5A0tQf1Wi80vgZXA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcWaqpTM8VDNdi6BYpa8R1tuoObFdE3QgVcgwoHXp7k=;
 b=j7WtMIgMlGWRZTuUEG0O0BMKFxX66uJUNiH6P+YLJ6TNAD3ltgOfaxbdyEDCMFT1CHsDVmDInzkdCJCGQVmb21qLkx0IKGZ6qjriEb4A+aqnQ5+qrXnUqCyvtd1w6VZuS1wEKVgjYP43oU/mukt+g+tE71kBzMk5KpjELb499MlZqGmrQh+szt1n2M1lBGIxqBCxhWha7YyHzhUsYYadrQWbiVyLJbk8RXU2dW35r0+vRYg9ebZUMLFl4CWPtF166cGWKsPUn/njw+xwDgjGR3Zp4JZ7uAHZaapAt8vK7BKJvbR4ZgMKqdB7B3xL7lOWa5bHO/SrQLYVqT9t1QqfhA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcWaqpTM8VDNdi6BYpa8R1tuoObFdE3QgVcgwoHXp7k=;
 b=jw4egqnZKtsPlreN6G7GDDEt+BabmLALJWib4+3xhgPwst8aV7I/t37m129M2yoFygoLG8cKrR5Lqm/qIMpkhMbqkJhFITNWXUDNq78tAQgCCKzjO7D6cBdjFZk5AFrhxQIvvDXRNAEEg6czwt0gW7wZ4wIpZCTdhJjLmhTRgaE=
Received: from VI1PR06CA0152.eurprd06.prod.outlook.com (2603:10a6:803:a0::45)
 by GV1PR08MB8691.eurprd08.prod.outlook.com (2603:10a6:150:85::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:48:21 +0000
Received: from MI3PEPF00008483.eurprd02.prod.outlook.com
 (2603:10a6:803:a0:cafe::eb) by VI1PR06CA0152.outlook.office365.com
 (2603:10a6:803:a0::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 08:48:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008483.mail.protection.outlook.com (10.167.240.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:48:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IXvv5Q4oPjhA/XF69JRF0Raixv4OkmoEDunZy8NWAGI4b5n6GcCOl5mTJVXKfyxNkC+7qZYUxoG/TpJQTJofAL1QF46dg2/LAHcgaYe3nnrIMDs/NNCAOX7x/TLbyebfo1rEMJoXmi3OyPtYHAaXb4v+oOSK95neDopJg9Ivr3Osn4haZnBW4q0UmbqPpuY2MMDOQR8C5rDdNXfxnMuXO+xrZfP1kf2QHj+JDro55c5+q7m+AAwrO4dL6rKYYKwDllMyi5YqI8W8zXrfKRByy0H8L7RCMja4wZG6dgnadzdXtKVpYW+hGKn0lL0u6giu38qtFp+I9ICsgnlJUbFkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcWaqpTM8VDNdi6BYpa8R1tuoObFdE3QgVcgwoHXp7k=;
 b=qLCH8XMvyTj9y2Ft5hc9mB71b1OUgr0257+u7CybXdjqi921Pr16q9CtiOZGPp8aZQLvcjfq9mWxieSRo4GdSzESAXiYH93h/CEBgnfYY3xlMxnh9arRQhhFolmaXOK3s2qI5Fq9EnNsqEGs4HIEEJXCDAOaodNjbVryoLDs06zgdDQcl5IKtOqHdjn/A56FPLBse0gFUkkypkKMHlqxDDKCN+kwzvRbRP00Sre0zauUQmZ+pQAHMTBstHaR2v/WB5R2mEaC/+DzcLPgV2+J3apUswE8MVDeByHorhxSJjc5bWpcSE4fc2YUi4fqFuCm3SRSneImo4SIpXrbIp80xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcWaqpTM8VDNdi6BYpa8R1tuoObFdE3QgVcgwoHXp7k=;
 b=jw4egqnZKtsPlreN6G7GDDEt+BabmLALJWib4+3xhgPwst8aV7I/t37m129M2yoFygoLG8cKrR5Lqm/qIMpkhMbqkJhFITNWXUDNq78tAQgCCKzjO7D6cBdjFZk5AFrhxQIvvDXRNAEEg6czwt0gW7wZ4wIpZCTdhJjLmhTRgaE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DB4PR08MB8101.eurprd08.prod.outlook.com (2603:10a6:10:387::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 08:47:47 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:47:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHdJl8SqSXvsSoqhkOSdrxgmJaLAraSpvKAgCuga4A=
Date: Fri, 4 Sep 2026 08:47:46 +0000
Message-ID: <4689ec951b2a526903573825b4ffd0bddb1c35bb.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-21-sascha.bischoff@arm.com>
	 <20260807143425.E88601F000E9@smtp.kernel.org>
In-Reply-To: <20260807143425.E88601F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DB4PR08MB8101:EE_|MI3PEPF00008483:EE_|GV1PR08MB8691:EE_
X-MS-Office365-Filtering-Correlation-Id: f03ce4d5-a15b-4496-04e7-08df0a614572
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Qkwx/2+66Dd3PGPx6wIyy9tyjSLmFd12fEdhwxRelvD8khTofpG4ijgPcUP8sUtUonFpcpZGZdTjJpGUnjK4hgSTxDrjWOoCGsO2zMWJ8w34O2vSBPsqpzgsSdqcMgvmKEqRQRm8rCxF8HNgQJOjk4gejClrU1/OR9ohtwoCKXq5iUlgn6nRi2bj5DaBHsvQ26YM9ckEVjCNdS00Hb2V1YMOhpLVW+gaqg7py2+RCyovtNsdFjZZZ2sk6iAVaKs2us0W02aWmx0FaJsgg3AckZ1OeEMN2ygjy8r0u/j9XcyMtmoF7KAV8T/x54Zut7x545fxOsbGjvGnFbpwXGYlQOjFJJvIbWeuAWDdI08fAsueO64EeNMbDZdGsqhfbJa1H7C5Un/cDKzmI+xxGYj9kaWSLRcKBw0ktlfNbHJt/Mcx8mJuT4ghnTfY7vZcNRQ+sw3oct6G6eKnNpDQ+cMr8BZlv1Kzr1C6o4L07Bdl+YPCHj4FjM0Eb+l2knghlfaKly7BpzHY4wL+rVrLa06g2dL/IG0mdMowqZeBmk+TdGVYbrmwX4AQ+786IjoOjK5tR4Lq6fb/qkqBt9HkQ/6jmLm5Uc63x4GJwFrEGL1Wasz16so0dM+UkiL/KjAEe9qZ9BlNWmOKePsakPW3w5JPvhPpD7FKRkvqn5DvMSyCq6R7XTRB2Tfq4AIhU/6b/r4fdCLl6Lw/iJtpZtLd+7sPbM8ECY4zjloO+yeqga+MZT4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E84E128841A2174FAB166957061A448C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 y1kk1y2JFYU0l4uch3H3KE2I+5ExFWGQMdWytCakDV0gi7CXVOgZPGmkQ3Jka0EKURcIvufzDAmB+aIrOCjIfBiOCa2tiggHOLwHkLAmzFY/j64hlqeYRQOVc8GEV5HGZCY0BLR7aTdN081zKBwXJ9e/gus9384j+5b4t/mumsRQFswZ/lAdp/teUPqjnCUsGYevC2ZeAa7uW96mJV4N0fYDDWiYD7cZrUe0F6aZlPiG7TerZPWzeiSPmxEdGgbttvfMdbNy1aDQ+cuOMZX2xIXKUFjRIWL0OmpmRxKp0ua97/sD6s/fT7g2QECvSw3bfS4T0ObBaoUnJb3eo0RLsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8101
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008483.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8abe1967-7a2e-41ec-a0eb-08df0a613175
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|35042699022|82310400026|36860700016|376014|1800799024|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r8AoFzAA7E1DUwR3lOX6TUzTIXBX7/MDEw0Uz/ErCmGwxQCP0eFcyaJo5sIteQxxQkVQrXa5qfmfohjWe2/CkVDdobDMljBmcP6UCjU7Ma2wlhJws7ukrhS4ysnTcQVYmSGdRybpvJQrPSokQKy+b+D9qwjSThxwx2+O2RbdozDkFZBlLIWcPDqdGQLJLXYEE0sQHW6Z9DyxWJcyNIa3xHiGJji/cSVKXREyjC0OL7gMdSA/hK4OW3zZGqkEqLHi6CYddGT45CTdJVgJxfTVB3wzm1cHRMc9D5o/lJ/A19n5bgk6lC1FlswswNAnNu/TARgFVxSS0Q2ixNN287ty9ATr15lzP8dEn9cN6f3VsHQaVDuEcylQ3q/pJ9xfTQEsDt7xdaMhMLCvO3jndQcT/6Od+kQ+VX7Oyf4yXHS2r2PoO8hFuR7Q68NTXLl2u+PR7jOXVTiJEmHDIPj+pvL5bsD5iLmeFXEvoCc099sXjLz8dDf2z0CfqYo86OD4xH6wnYKKYSuPHYxZN+YArx0WkosAuQPFUVQ+BxnXhOLBrmaAVw+jAYoCKgsXav6moIq8oLzEk2rf/Wjd6Ondjk3fdodvgowvwYF/tER66FbLdCOhnnKThOI3mC/24B/H4GbBgzg4vpNXetFA+9IkwtW/Qao428hRh1fv8zU1ewaFp7A=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(35042699022)(82310400026)(36860700016)(376014)(1800799024)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dwliEe9endgdAxhTpbe9TxQq90Hdax8DeycmoZ5qmfWTwE/eINLLqBe2+s96ZXXPqZuFb+g2RFr0ew4ll+BH20hJPRz9GK3Z6Cw0J2F8BjYh+jE+drJecWkDYpCT9y0lyNvC2oUlUZCBbXuW9HP5XtDiRMqTSA6yhlsZHbe6lkIk+nhn8GmZR8h1wPWBPYAeuCWwVkSor99YrrW/ZQEyIMijCEuxcf98/vEMGeQkSsMKPV2r5EWLwta8fxXZmdsY4RM3qr0/bjXZiyfHauIdewWVLCMUBBeTTVCIklYDeYQp3S/ieJFReWc5HyrMlWkNYnkDAUsrUEh52T13+geqilup+Zjxk4r54KHZCKCxT9U1Ob4qjb+nnWKTMR8ZWZ/4mmHR8Z8KeMv7b2wUb9ZOpdfxIED8SIBnxUoPZJQeg+e/IUGfZSWm92ckB4RvTmKw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:48:20.1246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f03ce4d5-a15b-4496-04e7-08df0a614572
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008483.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8691

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE0OjM0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gNjQtYml0IElSUyBNTUlPIHJlZ2lzdGVycyBsYWNrIHN1cHBvcnQgZm9yIDMyLWJpdCBhY2Nl
c3NlcywNCj4gbGVhZGluZyB0byB1bmhhbmRsZWQgTU1JTyBhYm9ydHMgYW5kIGJyb2tlbiByZWFk
LW1vZGlmeS13cml0ZQ0KPiBiZWhhdmlvci4NCj4gLSBbTWVkaXVtXSBNaXNzaW5nIGxvY2tpbmcg
aW4gdGhlIElSUyBJU1QgTU1JTyByZWFkIGhhbmRsZXIgYWxsb3dzDQo+IGd1ZXN0cyB0byBvYnNl
cnZlIGxvZ2ljYWxseSB0b3JuIHJlZ2lzdGVyIHN0YXRlcy4NCj4gLSBbTWVkaXVtXSBMb2NrbGVz
cywgc2VxdWVudGlhbCB1cGRhdGVzIHRvIEdJQ1Y1X0lSU19DUjEgY2FuIHJlc3VsdA0KPiBpbiBh
IHRvcm4gTU1JTyB3cml0ZS4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMjBdOiBbUEFUQ0ggdjUg
MjAvNDldIEtWTTogYXJtNjQ6IGdpYy12NTogQWRkIEdJQ3Y1IElSUw0KPiBJT0RFViBhbmQgTU1J
TyBlbXVsYXRpb24gLS0tDQo+IGNvbW1pdCBlM2Q3NDdhYzBlYzhiNjBiODk0MDkyYWQ0ZjJkYzBj
Nzk1OTQyM2VmDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJt
LmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTogQWRkIEdJQ3Y1IElSUyBJT0RFViBhbmQg
TU1JTyBlbXVsYXRpb24NCj4gwqDCoMKgIA0KPiBJbiBvcmRlciB0byBwcm9wZXJseSBzdXBwb3J0
IEdJQ3Y1LWJhc2VkIFZNcyBpbiBLVk0sIGVtdWxhdGUgdGhlDQo+IENPTkZJR19GUkFNRSBmb3Ig
YSB2aXJ0dWFsIElSUy4gVGhpcyBlbXVsYXRpb24gbmVlZHMgdG8gaGFuZGxlIGd1ZXN0DQo+IGFj
Y2Vzc2VzIHRvIHRoZSBNTUlPIHJlZ2lvbiBhbmQgbWltaWMgdGhlIGJlaGF2aW91ciBvZiBhIHJl
YWwgSVJTLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWly
cy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJzLXY1LmMNCj4gPiBuZXcg
ZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMDAuLmM2MjgwNzk1YWI1NTEN
Cj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWly
cy12NS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBAIC0wLDAgKzEsNzY1IEBADQo+IFsgLi4u
IF0NCj4gPiArc3RhdGljIHZvaWQgdmdpY192NV9tbWlvX3dyaXRlX2lyc19taXNjKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwNCj4gPiBncGFfdCBhZGRyLA0KPiA+ICsJCQkJCXVuc2lnbmVkIGludCBs
ZW4sIHVuc2lnbmVkDQo+ID4gbG9uZyB2YWwpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX3Y1
X2lycyAqaXJzID0gdmdpY192NV9nZXRfaXJzKHZjcHUpOw0KPiA+ICsJc3RydWN0IHZnaWNfZGlz
dCAqdmdpYyA9IHZnaWNfdjVfZ2V0X3ZnaWModmNwdSk7DQo+ID4gKwljb25zdCBzaXplX3Qgb2Zm
c2V0ID0gYWRkciAmIChTWl82NEsgLSAxKTsNCj4gPiArDQo+ID4gKwlzd2l0Y2ggKG9mZnNldCkg
ew0KPiBbIC4uLiBdDQo+ID4gKwljYXNlIEdJQ1Y1X0lSU19DUjE6DQo+ID4gKwkJaXJzLT5jcjEu
c2ggPSBGSUVMRF9HRVQoR0lDVjVfSVJTX0NSMV9TSCwgdmFsKTsNCj4gPiArCQlpcnMtPmNyMS5v
YyA9IEZJRUxEX0dFVChHSUNWNV9JUlNfQ1IxX09DLCB2YWwpOw0KPiA+ICsJCWlycy0+Y3IxLmlj
ID0gRklFTERfR0VUKEdJQ1Y1X0lSU19DUjFfSUMsIHZhbCk7DQo+ID4gKwkJaXJzLT5jcjEuaXN0
X3JhID0gISEodmFsICYgR0lDVjVfSVJTX0NSMV9JU1RfUkEpOw0KPiA+ICsJCWlycy0+Y3IxLmlz
dF93YSA9ICEhKHZhbCAmIEdJQ1Y1X0lSU19DUjFfSVNUX1dBKTsNCj4gPiArCQlpcnMtPmNyMS52
bXRfcmEgPSAhISh2YWwgJiBHSUNWNV9JUlNfQ1IxX1ZNVF9SQSk7DQo+ID4gKwkJaXJzLT5jcjEu
dnBldF9yYSA9ICEhKHZhbCAmDQo+ID4gR0lDVjVfSVJTX0NSMV9WUEVUX1JBKTsNCj4gPiArCQlp
cnMtPmNyMS52bWRfcmEgPSAhISh2YWwgJiBHSUNWNV9JUlNfQ1IxX1ZNRF9SQSk7DQo+ID4gKwkJ
aXJzLT5jcjEudm1kX3dhID0gISEodmFsICYgR0lDVjVfSVJTX0NSMV9WTURfV0EpOw0KPiA+ICsJ
CWlycy0+Y3IxLnZwZWRfcmEgPSAhISh2YWwgJg0KPiA+IEdJQ1Y1X0lSU19DUjFfVlBFRF9SQSk7
DQo+ID4gKwkJaXJzLT5jcjEudnBlZF93YSA9ICEhKHZhbCAmDQo+ID4gR0lDVjVfSVJTX0NSMV9W
UEVEX1dBKTsNCj4gPiArCQlyZXR1cm47DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gU2lu
Y2UgdGhlc2Ugc2VxdWVudGlhbCB3cml0ZXMgYXJlIHBlcmZvcm1lZCB3aXRob3V0IGhvbGRpbmcN
Cj4gY29uZmlnX2xvY2ssDQo+IGlzIHRoZXJlIGEgcmlzayBvZiBkYXRhIHJhY2VzPyBJZiBtdWx0
aXBsZSB2Q1BVcyBjb25jdXJyZW50bHkgd3JpdGUNCj4gZGlmZmVyZW50IHZhbHVlcyB0byBHSUNW
NV9JUlNfQ1IxLCBpdCBzZWVtcyBsaWtlIHRoZSBpbnRlcm5hbCBLVk0NCj4gc3RhdGUNCj4gZm9y
IGlycy0+Y3IxIGNvdWxkIGVuZCB1cCBpbiBhIHRvcm4gc3RhdGUgY29tYmluaW5nIHRoZSBjb25j
dXJyZW50DQo+IHdyaXRlcy4NCg0KV2hpbGUgSSBhZ3JlZSB0aGF0IHRoaXMgd291bGQgYnJlYWss
IGl0IHdvdWxkIGJlIGJyb2tlbiBzb2Z0d2FyZSwgYW5kDQp3ZSBkb24ndCBhY3R1YWxseSB1c2Ug
dGhlIHZhbHVlcyB3cml0dGVuIHRvIHRoaXMgcmVnaXN0ZXIgLSB3ZSBqdXN0DQpwcm92aWRlIHRo
ZW0gYmFjayB0byB0aGUgZ3Vlc3QgaWYgYW5kIHdoYXQgaXQgcmVhZHMgdGhlbS4gVGhlcmVmb3Jl
LCBJDQpkb24ndCB0aGluayB0aGF0IHRoaXMgaXMgd29ydGggdGhlIGV4dHJhIGNvbXBsaWNhdGlv
bnMgb2YgY2hhbmdpbmcgaXQuDQoNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gK3N0YXRpYyB1bnNp
Z25lZCBsb25nIHZnaWNfdjVfbW1pb19yZWFkX2lyc19pc3Qoc3RydWN0IGt2bV92Y3B1DQo+ID4g
KnZjcHUsDQo+ID4gKwkJCQkJwqDCoMKgwqDCoMKgIGdwYV90IGFkZHIsDQo+ID4gdW5zaWduZWQg
aW50IGxlbikNCj4gPiArew0KPiA+ICsJc3RydWN0IHZnaWNfdjVfaXJzICppcnMgPSB2Z2ljX3Y1
X2dldF9pcnModmNwdSk7DQo+ID4gKwljb25zdCBzaXplX3Qgb2Zmc2V0ID0gYWRkciAmIChTWl82
NEsgLSAxKTsNCj4gPiArCXU2NCB2YWx1ZSA9IDA7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChvZmZz
ZXQpIHsNCj4gWyAuLi4gXQ0KPiA+ICsJY2FzZSBHSUNWNV9JUlNfSVNUX0JBU0VSOg0KPiA+ICsJ
CXZhbHVlID0gRklFTERfUFJFUChHSUNWNV9JUlNfSVNUX0JBU0VSX0FERFJfTUFTSywNCj4gPiAr
CQkJCcKgwqAgaXJzLT5pc3RfYmFzZXIuYWRkciA+Pg0KPiA+IEdJQ1Y1X0lSU19JU1RfQkFTRVJf
QUREUl9TSElGVCk7DQo+ID4gKwkJaWYgKGlycy0+aXN0X2Jhc2VyLnZhbGlkKQ0KPiA+ICsJCQl2
YWx1ZSB8PSBHSUNWNV9JUlNfSVNUX0JBU0VSX1ZBTElEOw0KPiA+ICsJCWJyZWFrOw0KPiANCj4g
W1NldmVyaXR5OiBNZWRpdW1dDQo+IENhbiBndWVzdHMgb2JzZXJ2ZSBsb2dpY2FsbHkgdG9ybiBy
ZWdpc3RlciBzdGF0ZXMgaGVyZT8gVGhlIHdyaXRlDQo+IGhhbmRsZXINCj4gdmdpY192NV9tbWlv
X3dyaXRlX2lyc19pc3QoKSBjb3JyZWN0bHkgaG9sZHMgY29uZmlnX2xvY2sgdG8NCj4gc2VxdWVu
dGlhbGx5DQo+IHVwZGF0ZSBpcnMtPmlzdF9iYXNlci52YWxpZCBhbmQgaXJzLT5pc3RfYmFzZXIu
YWRkciwgYnV0IHRoaXMgcmVhZA0KPiBoYW5kbGVyIGFjY2Vzc2VzIHRoZW0gbG9ja2xlc3NseS4g
SWYgYSB2Q1BVIHJlYWRzIEdJQ1Y1X0lSU19JU1RfQkFTRVINCj4gY29uY3VycmVudGx5IHdpdGgg
YSB3cml0ZSwgaXQgY291bGQgc2VlIGFuIGltcG9zc2libGUgc3RhdGUgY29tYmluaW5nDQo+IHRo
ZQ0KPiBvbGQgYWRkcmVzcyB3aXRoIHRoZSBuZXcgdmFsaWQgYml0IG9yIHZpY2UtdmVyc2EuDQoN
CkFzIGFib3ZlLCB0aGlzIGlzIHNvbWV0aGluZyB0aGF0IHdlIHNob3VsZG4ndCBuZWVkIHRvIGd1
YXJkIGFnYWluc3QuIElmDQpzb2Z0d2FyZSBib3RoIHdyaXRlcyBhbmQgcmVhZHMgdGhpcyByZWdp
c3RlciBhdCB0aGUgc2FtZSB0aW1lIGZyb20NCm11bHRpcGxlIHZDUFVzLCB0aGVuIHRoYXQgc29m
dHdhcmUgc2hvdWxkIGV4cGVjdCByYWNlcy4gRnJhbmtseSwgdGhpcw0KaXMgYnJva2VuIHNvZnR3
YXJlLCBhbmQgaXQgd2lsbCBwb3RlbnRpYWxseSBnZXQgZ2liYmVyaXNoIGJhY2suDQoNCj4gDQo+
IFsgLi4uIF0NCj4gDQo+ID4gK3N0YXRpYyB2b2lkIHZnaWNfdjVfbW1pb193cml0ZV9pcnNfaXN0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiBncGFfdCBhZGRyLA0KPiA+ICsJCQkJwqDCoMKg
wqDCoMKgIHVuc2lnbmVkIGludCBsZW4sIHVuc2lnbmVkDQo+ID4gbG9uZyB2YWwpDQo+ID4gK3sN
Cj4gPiArCXN0cnVjdCB2Z2ljX3Y1X2lycyAqaXJzID0gdmdpY192NV9nZXRfaXJzKHZjcHUpOw0K
PiA+ICsJY29uc3Qgc2l6ZV90IG9mZnNldCA9IGFkZHIgJiAoU1pfNjRLIC0gMSk7DQo+ID4gKwll
bnVtIGdpY3Y1X3ZjcHVfY21kIGNtZCA9IExQSV9WSVNUX01BS0VfSU5WQUxJRDsNCj4gPiArDQo+
ID4gKwlzd2l0Y2ggKG9mZnNldCkgew0KPiBbIC4uLiBdDQo+ID4gKwljYXNlIEdJQ1Y1X0lSU19J
U1RfQkFTRVI6IHsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlzIHN0cmljdCBt
YXRjaGluZyBvbiBleGFjdCBvZmZzZXRzIGJyZWFrIHJlYWQtbW9kaWZ5LXdyaXRlDQo+IGZvcg0K
PiAzMi1iaXQgYWNjZXNzZXMgdG8gdGhlIGhpZ2ggaGFsZiBvZiB0aGUgcmVnaXN0ZXI/IElmIGEg
Z3Vlc3QgcGVyZm9ybXMNCj4gYQ0KPiAzMi1iaXQgd3JpdGUgdG8gb2Zmc2V0ICsgNCwgaXQgbG9v
a3MgbGlrZSB0aGlzIHN3aXRjaCBzdGF0ZW1lbnQgZHJvcHMNCj4gaXQuDQo+IEFsc28sIGludGVy
cHJldGluZyBhIDMyLWJpdCBwYXlsb2FkIGFzIGEgZnVsbCA2NC1iaXQgdmFsdWUgd2l0aG91dA0K
PiBhZGp1c3RpbmcgZm9yIHRoZSBvZmZzZXQgd291bGQgY29ycnVwdCB0aGUgcmVnaXN0ZXIgc3Rh
dGUuDQoNCkkndmUgZXh0ZW5kZWQgdGhlIGFjY2Vzc29ycyB0byBjb3BlIHdpdGggMzItYml0IGFj
Y2Vzc2VzIGZvciB0aGUNCklSU19JU1RfQkFTRVIuIFRoaXMgaXMgdGhlIG9ubHkgaW1wbGVtZW50
ZWQgcmVnaXN0ZXIgd2UgaGF2ZSB0aGF0DQpzdXBwb3J0cyBib3RoIDMyLSBhbmQgNjQtYml0IGFj
Y2Vzc2VzLiBUaGUgcmVzdCBhcmUgUkFaL1dJIGluIHRoZQ0KY3VycmVudCBpbXBsZW1lbnRhdGlv
bi4gSSd2ZSBhbHNvIGVuYWJsZWQgdGhlIDMyLWJpdCBhY2Nlc3NlcyBmb3INCnRob3NlLCBidXQg
dGhleSBoYXZlIG5vIGVmZmVjdHMgb3RoZXJ3aXNlLg0KDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+
ICtzdGF0aWMgY29uc3Qgc3RydWN0IHZnaWNfcmVnaXN0ZXJfcmVnaW9uIHZnaWNfdjVfaXJzX3Jl
Z2lzdGVyc1tdID0NCj4gPiB7DQo+IFsgLi4uIF0NCj4gPiArCVJFR0lTVEVSX0RFU0NfV0lUSF9M
RU5HVEgoR0lDVjVfSVJTX0lTVF9CQVNFUiwNCj4gPiB2Z2ljX3Y1X21taW9fcmVhZF9pcnNfaXN0
LA0KPiA+ICsJCQkJwqAgdmdpY192NV9tbWlvX3dyaXRlX2lyc19pc3QsIDgsDQo+ID4gKwkJCQnC
oCBWR0lDX0FDQ0VTU182NGJpdCksDQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IENvdWxkIG9t
aXR0aW5nIFZHSUNfQUNDRVNTXzMyYml0IGZvciB0aGlzIDY0LWJpdCByZWdpc3RlciBjYXVzZSB0
aGUNCj4gS1ZNDQo+IElPIGJ1cyB0byByZWplY3QgdmFsaWQgMzItYml0IGd1ZXN0IGFjY2Vzc2Vz
PyBJZiBLVk0ncyBtbWlvDQo+IGRpc3BhdGNoZXINCj4gcmVqZWN0cyBhIDMyLWJpdCBhY2Nlc3Ms
IHRoZSByZXF1ZXN0IHdpbGwgZmFsbCBiYWNrIHRvIHVzZXJzcGFjZSBJTy4NCj4gU2luY2UNCj4g
dXNlcnNwYWNlIGRvZXMgbm90IGVtdWxhdGUgdGhlIGluLWtlcm5lbCBJUlMsIHRoaXMgdXN1YWxs
eSByZXN1bHRzIGluDQo+IGFuDQo+IHVuaGFuZGxlZCBkYXRhIGFib3J0IGluamVjdGVkIGludG8g
dGhlIGd1ZXN0Lg0KPiANCg0KU2VlIG15IGNvbW1lbnQgYWJvdmUgLSBJIGhhdmUgYWRkZWQgMzIt
Yml0IGFjY2Vzc2VzIGZvciB0aGUNCklSU19JU1RfQkFTRVIuDQoNClRoYW5rcywNClNhc2NoYQ0K
DQo=
