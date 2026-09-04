Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012057.outbound.protection.outlook.com [52.101.66.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DE4854FC
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523105; cv=fail; b=LgSoWyfJ/DEVL1x7CO6BMp0nbuPgxJL62SlqV99h8NVeITY+rPxbQtNXX0zNJo6Ss4yWSKBRpUr8f+PiL+SReO6PPaXB++V4UeVCVAnaJIJ1LA5N9iKyeoAGofMesN8cWe9Tr8MNqtQKKTSQA1mhkzlxCIenc6QXecHABXE7mnA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523105; c=relaxed/simple;
	bh=a2aVVikrXZ6INAAfqXczq6Hzcgn6oXHCZjuhU7rfJfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AcAX5C6AX2Evkw0+BnF/Qi7RItcf6DTiBY6yDwpYf59kuGez6s3wrdsYQ4eY3ht9CMddj5BkewkYn/MbsUTXWrVUoOIN6xFvYCrNXmK1FLsXz6I/1USEPDNLBkGplTycAhp2fXIut6qV9ubeGqCQlnPVIawqazb/qI77cRgKoWc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RSYnzyWB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RSYnzyWB; arc=fail smtp.client-ip=52.101.66.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RSYnzyWB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RSYnzyWB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tVkMlofOAS8P8oY2XPSMSrZlTk+CQj23stlwi9Dieazvv5BevGArK+hCiIv4yX5G7JZQ65Lw9y7DsHERboVWPJojYItZPGF+mp7yQemN0SE1cU4iYhZBF5596SzyT11dxy7PN+44YXcTlP7z5/rsy7stn3PK+x5sxr27L15m99MPhUrsm0JM7FdkGaMHMRf8GxwBAwJR+9F06rHy8lfSOx5jjATKL37/+/zVSD+aKS5GWVzwChHIIeuSExAPYlW083pDQq4aMrqPTKymfh8lz9Z1yfMo1Jlj57Mc3UNxa7BmbNMitNUoucWWL2pzi/YB36+wPa8tmfjAUZWvEk24ow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1HZG77ZN+WVGuBjNwLxiDXXtcOtJUb+7wEG6gkPwrE=;
 b=CnR/lTM5NozrOqAN1WxrkaTPIrx91xcCe4Sv0ey7rZuSIhDUmIy2z9dztmEBzDu49t2Pd4HZfxIi26vyNJtHWHJX+5VanWegqJYAp/4ddn2xRx6UBFs8q4zfcL798A5+8wxzeyZtlroXiMJsCilwQSKKDREWZUJARpiLhy4TDaSchsWz/2j+Kd97auEy97m2mXg8XzjU2LzxzE8/gsmVik4ttRajSRUuTMbbnxL/vNQKiMEm6ekytQdX9KcPULfcxhHNaGPJi0KxUOwbvzxZkcJNl/wHw+tIxQ24NOsxaYnTW2Ietu3RZaf287+E6ipaHERwUzpA219gtK5z0mN7bA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1HZG77ZN+WVGuBjNwLxiDXXtcOtJUb+7wEG6gkPwrE=;
 b=RSYnzyWBzH8Wh4278vPztvGvPcLQtyCGmrUSpVYNR0PV3QN8bl9ym+83jcb+XcpyIigYt3abTWewThykgP76+13DKJehwD+rUazMW1wG8hEnD9FxF+18tAUvXBZZxmXF04MqgRuNnVmqg3VUrxrKF+uwjP3VjauUscB77v9JilA=
Received: from PR1P264CA0010.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19e::15)
 by AMCPR08MB11994.eurprd08.prod.outlook.com (2603:10a6:20b:76d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:58:17 +0000
Received: from MI3PEPF0000847F.eurprd02.prod.outlook.com
 (2603:10a6:102:19e:cafe::3b) by PR1P264CA0010.outlook.office365.com
 (2603:10a6:102:19e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:58:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF0000847F.mail.protection.outlook.com (10.167.240.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSYG8IsHiqxugxK/6QnNpQG547JNIye/SP8lJdiUrKhJZVhnqaa/GkrG6jp6cQQXSe0SCPWZDprNawaUkonV2EIcZAUMKV5AYxgXzNrz5JWEQ4m/LbEjJ3cX3m8itIpzlYhdaDFMmGwKqGV2jbpV7iImL4ppUZwAcVqa6nOOi6+hb2SqiPoxRdxQayPDzqopX9CwwcNKlT6iXQNoaUzNmKrvNeGnNqqRw2TdhDnVgPKrfExAlycaAdkMHhg5MYz8owd/GxlArjcu3eOsYqz7eXEj5bxPqALl7G6ZMDQi/YRhFTrL6QOW0XZECq0DTjk9KX84NCQjdeLlXpzUvIp/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1HZG77ZN+WVGuBjNwLxiDXXtcOtJUb+7wEG6gkPwrE=;
 b=qd5KpZRcWIXZZdY2PlVljK5oCkd0DTUdrVeOUYcXdG/sxJl/PHvQ0bY88vBkJngipfDtvRDXBVlGjWQAyl9ISxGbLjS5Hu2WCKCKKwVqyEuqZ0TXDFf73LUt6ASUdVYzrKuC+4yzhmBTZt+tjDxXsnQsULjvr9BqdbKIcmbVxJ+tU4vSPl4fGs0QnKakiK4/cdbXP+3E8sduQ470tuKq7HGvZXTrKYa8GY9PJYegBb8fLOzPwYBSYWxyOxl4IRfALCQMzKTnzxEk4+ka5HcxzNJqEC7e3l2SYewDS13x+a/QmwZcFARwexGkLPlqcn21o65YiDcPY51tF/0eUHeOZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1HZG77ZN+WVGuBjNwLxiDXXtcOtJUb+7wEG6gkPwrE=;
 b=RSYnzyWBzH8Wh4278vPztvGvPcLQtyCGmrUSpVYNR0PV3QN8bl9ym+83jcb+XcpyIigYt3abTWewThykgP76+13DKJehwD+rUazMW1wG8hEnD9FxF+18tAUvXBZZxmXF04MqgRuNnVmqg3VUrxrKF+uwjP3VjauUscB77v9JilA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:57:40 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:57:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 46/49] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Topic: [PATCH v6 46/49] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Index: AQHdPGSVlW5r99NSqE+L24CliM64+Q==
Date: Fri, 4 Sep 2026 11:57:39 +0000
Message-ID: <20260904113404.4051341-47-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|MI3PEPF0000847F:EE_|AMCPR08MB11994:EE_
X-MS-Office365-Filtering-Correlation-Id: eeed43cf-e8f1-4d08-178d-08df0a7bce5c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 rBubNLoveL/hN5FDDJV3mpvBh4LwnuOw4Yi3H3KVh9EKuwxm12gnVT/S13FFHpN7Wu8iTaiKwqd5ERJqKQPR5Y+DcND+HCWg/JBKD/XYwqiKq2ngPZOG1eCIYXQTTvE5igQhOzwl9+nJvdMg5hAhICayWD6hg9ehlW9bY9CV1nY5nuKqcle47mYntStUkmwtunneeSWy8jfUXk6SB6xdrpOBOkwOw8tqRt4OHb3GQ9pOGRTRHeOGBPUads7Fs0APai9rM4oqQRGP4o44gER4LY88DVD03nkxY+arIExfCsoQpeQj+DAGOgSRAhKGP6LM0ZlNpKIF7ECDxPrBoZetg0loFDPl80evaEob1exJGQ98tBhHCliqXo0EUR6Gts9iSE7M8EcVu+RCnORXP+jDwgf9Sq803vbaEBBDBKYraNRA0k6PPc3utyYD4pMtqVpujlzC/+dD7nKVbmj9HLCdY9N5460rcvnF/v7+pKOS1/bf2xOQZCbx+0uLNz7ID/Ux76ctdL/6Lz6nLGZZGuFwIPzh6TbdyhiYQidfEBZdWZaFnRxaJLjz0sGVTwg8KQdY+9APCbULCWueRhq9Y7WbPl3q9Eq3qsUbVCIOlaHnkD6tUpzSTRmroMn8cv44gMh0I8Ym+LVmRHL5TyAGVqv+MvPr2i/MKh5j1wlNECoeGPMbFlWl8hpbeHiFCKqxSJFUtrGP4tURqtR1t8dkGuqx849jnZBe70nO8vYpZ6JEkwQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jXJGECCwuJe27lFjDshzVAqSKWOFnP+u/z/9LVy7gJ7EAyLcFU3NnyYUlcvRJjYsmghlVFJZltAuFzpx6OxiCCkm7oFiz4zP2ot71EFpEAIoMsSvT4g0Zav7KmzAJ9mWiRUE9KOcJgcDNH/PAdllu+TLueQ/i829B+1u29y9tELiOLdvK/xorPB6yWDgeeTKzKkQ9SwHrbA6+UicHxmfrz+sbKDF4o+q1zNjebZfQfRgzXQ1NQmAdK3M9J/BApZ9L0Rj/FBoFBhHsdfHpQIQsUygRDeMs9teh+ycLJs5pyNmRjxHhc+Y6ksNVFNGaXNIjQMZNf9qoEN7MBYw7CVGWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF0000847F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5967910-8ba2-4afc-f675-08df0a7bb7f8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|14060799003|35042699022|23010399003|376014|6133799003|18002099003|22082099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	xErnmsTkZ2f8w/mkHecvENUTqeBCAtYR+5d4tXjtMLy2uqMO0PitNiXExJfjLYd7IVZcKV0fHoTvdAARNCI7GEUA2JFHuPJuEgC2gGFd21zK2VpUNigZgqYiGvNbIzkHWf2vM8aY/fV3dnYp+rzg5Fr9+StBeqI4iAlem9CioinlapoYGhY2iLNbo1ld/t+YZ5KNyWRU/Vc/OqyX3vV4s5OTY8MRmSYG6GtNsRrADIc5qdi+pa7RlxxYKbDEl+BlRuH1d67SYPIVhsc4T14Zpajdmht914BfkAWAu5l73ixcotVA2m47Cib7DXixxr04C1a0ak0Aj7M6fwY1QX5CQEi+gIja1ttZ5FKvrX23oh4eOFBROow8JJJnZ5dxQpSA2RhS3PngP7CH8egP3b/+2mDOe1aC4v1GBKS7cCixiL5zq+havDudvsBIYH2tAPangI12vMz196qE748uKmu0VeF6neEGAr/X7/5B7pJQKrvkOpzNKB6mgNjIScbfM23kDnCqkZ8RzTAcLH5FDush6s+fHDtjnZC/gofh9iBC2pfprn2RWyBpLUZP9HylqLp9ycublBcXWfaT068wusZFIAX/3PPltQcjTReddb3tzGQMM1Il7G0buwaxhimQ534/pYXa3ScRyHy1lyFrRUDWffF2a9Va8aVJv5zXA2I40S8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(14060799003)(35042699022)(23010399003)(376014)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	z9vpG804ybJdGqTCFS1MCN9bJsqNs2Jy6XWoFBdjq3/ffvRmRq8KY+/6NR/C/EmGgpAYdl+t2saivtoitZ13NvRkmacG9cus5u8Iw3OnGmj0k5C84yVq6RVOohz7YddrZiTdscWaKlZDnhJeAdxYVRkrWpJ5L1KYqfOpt5qfhsBZKnnZz3DWDIhia4ZwkpYop9keSr5j31hEhfj137fIv4bQ1GzxLEbtleJTybWt1BLzrCMUgDra2TotbeVf43fjvoPwIyvIY8aahHZhibpHAxMS61ay7TtsoMrL8IKMPcNDAB4ompgeAjmRQV6pJ8gngY7IHpr5bm6w10o89Z4/LekmxA71qMWMG8cOkW/S/sn98LjDyeSBXpSLDqSeGhpJCmLKniC71Xufy0crRxA7fhAgHOrDPrmGCAClpV+/eayWH0ATmaTGUrguO8f2lCGo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:58:16.7340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eeed43cf-e8f1-4d08-178d-08df0a7bce5c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF0000847F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB11994

Add VGICv5 SPI delivery coverage through KVM_IRQ_LINE. SPIs are
configured through the virtual IRS and delivered through the GICv5 CPU
interface, so the test needs to exercise both the userspace injection
path and the guest-side IRS programming path.

Map the virtual IRS into the guest, enable the IRS, configure SPI
trigger mode and target VPE from the guest, and check delivery of a
default SPI and SPI 1023, the last SPI in the maximum configured
range.  This also exercises VGIC initialization and the IRS selector
at KVM's upper bound. Verify that invalid SPI numbers are rejected,
that lowering an edge-triggered SPI after it is pending does not
recall it, and that level-sensitive SPIs are delivered.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 258 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  11 +
 2 files changed, 264 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index f294e58f6b50d..ea3451d850c22 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -16,6 +16,8 @@
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(10)
+#define VGIC_V5_IRS_SIZE		0x20000
+#define VGIC_V5_IRS_WAIT_RETRIES	1000000
=20
 static u64 max_phys_size;
=20
@@ -43,7 +45,71 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi=
_ist, size_t spi_size,
 	};
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static u32 spi_line_expected;
+static bool spi_line_level_sensitive;
+
+static u64 gicv5_spi_hwirq(u32 spi)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+}
+
+static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK,
+				 GICV5_IRQ_DEFAULT_PRI);
+	gic_insn(val, CDPRI);
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
+	gic_insn(val, CDAFF);
+
+	gic_insn(hwirq, CDEN);
+}
+
+static void gicv5_enable_spi(u32 spi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
+}
+
+static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
+{
+	int i;
+
+	for (i =3D 0; i < VGIC_V5_IRS_WAIT_RETRIES; i++) {
+		if (readl(GICV5_IRS_CONFIG_BASE_GVA + reg) & idle)
+			return;
+
+		cpu_relax();
+	}
+
+	GUEST_FAIL("IRS operation did not become idle");
+}
+
+static void gicv5_configure_spi(u32 spi, bool level)
+{
+	u32 val;
+
+	val =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, spi);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_SELR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+
+	val =3D level ? GICV5_IRS_SPI_CFGR_TM : 0;
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_CFGR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+}
+
+static void gicv5_enable_irs(void)
+{
+	writel(GICV5_IRS_CR0_IRSEN,
+	       GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_CR0);
+	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
+}
+
+static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
 	u32 hwirq;
@@ -100,6 +166,49 @@ static void guest_code(void)
 		cpu_relax();
 }
=20
+static void guest_spi_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	GUEST_ASSERT_EQ(hwirq, gicv5_spi_hwirq(READ_ONCE(spi_line_expected)));
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_DONE();
+}
+
+static void guest_spi_line_code(void)
+{
+	local_irq_disable();
+
+	gicv5_enable_irs();
+	gicv5_cpu_enable_interrupts();
+	gicv5_configure_spi(READ_ONCE(spi_line_expected),
+			    READ_ONCE(spi_line_level_sensitive));
+	gicv5_enable_spi(READ_ONCE(spi_line_expected), 0);
+
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -112,6 +221,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static void vgic_v5_map_irs(struct kvm_vm *vm)
+{
+	unsigned int nr_irs_pages;
+
+	nr_irs_pages =3D vm_calc_num_guest_pages(vm->mode, VGIC_V5_IRS_SIZE);
+
+	/* Map the IRS at VA =3D=3D IPA so guest MMIO writes hit the IRS IODEV. *=
/
+	virt_map(vm, GICV5_IRS_CONFIG_BASE_GPA,
+		 GICV5_IRS_CONFIG_BASE_GPA, nr_irs_pages);
+}
+
 static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
 {
 	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
@@ -123,6 +243,93 @@ static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 t=
ype, u32 num, int level)
 	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
 }
=20
+static void vgic_v5_spi_line(struct kvm_vm *vm, u32 spi, int level)
+{
+	int ret =3D __vgic_v5_irq_line(vm, KVM_ARM_IRQ_TYPE_SPI, spi, level);
+
+	TEST_ASSERT(!ret, "KVM_IRQ_LINE failed for SPI %u level %d",
+		    spi, level);
+}
+
+static void vgic_v5_spi_line_vm_create(struct vm_gic *v,
+				       struct kvm_vcpu **vcpu,
+				       u32 nr_spis)
+{
+	u64 attr;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+	*vcpu =3D vm_vcpu_add(v->vm, 0, guest_spi_line_code);
+	TEST_ASSERT(*vcpu, "Failed to create vCPU");
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_spi_irq_handler);
+	vcpu_init_descriptor_tables(*vcpu);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0,
+			    &nr_spis);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
+static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
+				      bool level_sensitive,
+				      bool lower_before_run)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	struct ucall uc;
+	int ret;
+
+	spi_line_expected =3D expected_spi;
+	spi_line_level_sensitive =3D level_sensitive;
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, nr_spis);
+
+	sync_global_to_guest(v.vm, spi_line_expected);
+	sync_global_to_guest(v.vm, spi_line_level_sensitive);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 IRQ_LINE guest did not become ready");
+
+	vgic_v5_spi_line(v.vm, expected_spi, 1);
+	/*
+	 * For edge-triggered SPIs, a following low transition must be ignored:
+	 * once the edge has made the SPI pending, it cannot be recalled. This
+	 * allows us to test that.
+	 */
+	if (lower_before_run)
+		vgic_v5_spi_line(v.vm, expected_spi, 0);
+
+	while (1) {
+		ret =3D run_vcpu(vcpu);
+		TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	vm_gic_destroy(&v);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -860,7 +1067,8 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
=20
 	vm_init_descriptor_tables(v.vm);
-	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT,
+				     guest_ppi_irq_handler);
=20
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
@@ -916,9 +1124,9 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
=20
 				kvm_irq_line(v.vm, irq, level);
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
-				pr_info("Guest skipping WFI due to pending IRQ\n");
+				pr_debug("Guest skipping WFI due to pending IRQ\n");
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
-				pr_info("Guest acknowledged IRQ\n");
+				pr_debug("Guest acknowledged IRQ\n");
 			}
=20
 			continue;
@@ -938,6 +1146,44 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_spis(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	int ret;
+
+	/* Default NR_IRQS exposes 32 SPIs, numbered 0..31 in KVM_IRQ_LINE. */
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_DEFAULT_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_DEFAULT_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted first invalid SPI=
");
+
+	vm_gic_destroy(&v);
+
+	/* Basic SPI injection through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 0, false, false);
+
+	/* The last valid SPI in the maximum configured range is injectable. */
+	vgic_v5_run_spi_line_test(VGIC_V5_MAX_NR_SPIS,
+				  VGIC_V5_MAX_NR_SPIS - 1, false, false);
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_MAX_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_MAX_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted configured invali=
d SPI");
+	vm_gic_destroy(&v);
+
+	/*
+	 * Edge SPIs remain pending after the line is lowered.  The low
+	 * transition is injected before the guest runs and must be ignored:
+	 * once an edge interrupt is pending, lowering the line cannot recall it.
+	 */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 1, false, true);
+
+	/* Level SPIs can be raised and delivered through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -987,9 +1233,11 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 CPU sysreg attrs\n");
 	test_vgic_v5_cpu_sysreg_attrs();
=20
-
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
+
+	pr_info("Test VGICv5 SPIs\n");
+	test_vgic_v5_spis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 0ad6dcc3d510b..091d9dbd3c01d 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -12,6 +12,7 @@
=20
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+#define GICV5_IRS_CONFIG_BASE_GVA	((volatile void *)GICV5_IRS_CONFIG_BASE_=
GPA)
=20
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
@@ -79,6 +80,12 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_CR0_IDLE		BIT(1)
+#define GICV5_IRS_CR0_IRSEN		BIT(0)
+
+#define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
+#define GICV5_IRS_SPI_CFGR_TM		BIT(0)
+
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
@@ -155,6 +162,10 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+#define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
+#define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_SPI		0x3
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
