Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010027.outbound.protection.outlook.com [52.101.84.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64D35F5ED
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102361; cv=fail; b=S1eJ/SVLDnyxaQ87C2BaRfRL0fnGuSi4kHrSfUxO6ruSmeZgPnlJK+ptSFNfgV89w1z4T5pbvxSx8Wy4AeCSaKtVgg7Q2ByY0fDkL2zeuDGi4JTR+wricN1uzPh7Ugiw+relECWMwin94g3Z8/TwyxSEOQg7sB8W2cwsb8q2p5w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102361; c=relaxed/simple;
	bh=K3k8t+96ewAfdxLdSNrHErRhtNJBnVdccCW79Icags8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d0DBslS/0Hw3DbRrqJp/Mjz+/cgGMeSUaECMrNXy2wGHTpfI9RCROuTs7Xa1WBiRjCfcSO9U8lIysJbJYe1MYce56ODD+KUVFEUkQ89m9UIp3BZHJ00DZ96bbMgJB586QIvCu7R6KuLWBqR0hdS6FP+ASxQ/oLo4EIR//ghblp4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FU4wTA7F; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FU4wTA7F; arc=fail smtp.client-ip=52.101.84.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FU4wTA7F";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FU4wTA7F"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UQthL3MWjKEPVYLB23u2tAerOwNpJk2jFq38Sxeo/Av/dbFW26J2u6mGgHrwVOIifKFClSieDLcOwwPejMtv035IyhR8svrvxTc6TAgcW+ScZC32EbPH01jGRQ+IsNL2IDerIvfJ3yQrJtieLNdbLbtM5/fCrDh383Zs2COnnaP9ARMFaYY2wci7UtVUlcEOGbbb4qzTtgKwSFR6WI141hPTlQ6aldImMDglglc0jB3i7kOoIZesUTV40u7P9911aM0jvxLGYVZw6JW6naQxcdmSVBxkqNRFHIk1nVGOkn/QiBzAYvS0T4E1VjbbAsq37jvPs2gI0cKXzWEwKkjzmA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLolhMT2BbE4iRvFcUNGm6XK2kGfjXvJEmcFvuy6a9o=;
 b=yoDkfJshFEhEjfCi8AywVKsY6vw3Ge8I7i0OcYyzKEUb09Oaqoqf/cLT2mtXnjGkXCFQa1Ptm4JZyak/qXLJ/zJSgc9l35JeJvEWFOyvZ9qRt4tLAIlWHKl75Ynyeflrdiuxn6055Esoji+tkRFkeJiyJqRPnyTBKX+Ov3ppDib1fZ4/peEYXV+Pic6ex2RFag04J63vlvCJ3K8Jf5joCBtbLGcbGz/6AB4TGrLcmPFlL230NpK9H/J/MMo6wBwAHP2CSIKPzOIqLHqeq5vBGHOJT9R0IiuDGKnbws1QKlkANo2udMxmjhO2Unp1E2cLQ8wcOuv4BIFTLSWJ9TWJlA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLolhMT2BbE4iRvFcUNGm6XK2kGfjXvJEmcFvuy6a9o=;
 b=FU4wTA7FXY98kUQtjz6K+mZeVvQTsbvbXD+D1C9agpOc2ZK9voupiUjNBdW7KIXP/EkUsvsUx7zqMeocOgMtGCHy5f70eX3esp/Q+qpTJKsJMzhkVjTzftmfvwBih1bbKcIZJQChrOKMRFKk3Cez4MXmTks3OruSgOl8mzBACzs=
Received: from AS4P189CA0007.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::18)
 by GV2PR08MB7929.eurprd08.prod.outlook.com (2603:10a6:150:ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:32:32 +0000
Received: from DB3PEPF0000885C.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::55) by AS4P189CA0007.outlook.office365.com
 (2603:10a6:20b:5d7::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:32:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885C.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:32:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVX5gI3+IneyQUpzdDTC4jg1jlNltTQ0Mz1sINsD3lG3dPJ/9iEA88pI6pkEt997oWsEsbUrL00brgiqe0b3MP7wIN51ock6uY1GNtQJfceAP5Wx+RW/qQS7ZNtKpFnoeQKY8HtomOizHSQ8L0Gg+t65j7cT2f7wuwTcmiVzrqFH/a7cQyyCdgd06+InTROZqawJHjxUysmEDshoAhdPnZ9ZoFfbLlpOdmKDkrmnJXu25RcLKgsBJKFy+ILTCQpG+h18QGcMCaHjQ/K5Q217Ov7aI+/Vt0BZvMFXaqRLIUUhwa33Pi5gba/GRq3Va906DRLAsWnvxKszaPh/K730Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLolhMT2BbE4iRvFcUNGm6XK2kGfjXvJEmcFvuy6a9o=;
 b=FXtFRdHB3QORSHIiLN1kLFNuUgKg03vlkkEhloG22jIHS9nQV7R4FUxsRsy+GEf/KoKDytzU7O5K/YXMO6C1EkEC/n3ohlMtU8JczwLM81f2ljWsd6b1cqXa1SrHnhJB9uODRqlQVvi5BHbPuopMq8A+ypG8kJVbYFeK5ZrgC66tmp7fNSG81Pnk3JkUkVXdeYkmvAsFobrPaPGXigO9Un9kIozdeYrffGMulnNBWjMCacOuPx+VDJ3pNIic3AN3lyUBbnDth4M0N6TaFctwzHUcRW0Z9VRnyDhOmgQhAWo/RuwR7w0vK+gv6Cfc/2Il8jeO5Oh/RVkxpTXgOMeFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLolhMT2BbE4iRvFcUNGm6XK2kGfjXvJEmcFvuy6a9o=;
 b=FU4wTA7FXY98kUQtjz6K+mZeVvQTsbvbXD+D1C9agpOc2ZK9voupiUjNBdW7KIXP/EkUsvsUx7zqMeocOgMtGCHy5f70eX3esp/Q+qpTJKsJMzhkVjTzftmfvwBih1bbKcIZJQChrOKMRFKk3Cez4MXmTks3OruSgOl8mzBACzs=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:31:58 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:31:57 +0000
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
Subject: [PATCH v5 38/49] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v5 38/49] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHdJmBarK0nXhJkxkumG/rHVO0EVw==
Date: Fri, 7 Aug 2026 11:31:57 +0000
Message-ID: <20260807111159.429128-39-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DB3PEPF0000885C:EE_|GV2PR08MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: fe182469-d635-4c36-c166-08def47791eb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 zKwapTTSJLpG55oHAZ5sQtOXTJAHb3pKBfYyimvgC/XJehC3BTUdQvWOMbCufxjd4UMkndheNpeaU56SgyqOX+lx1GnsoQsRZ5UZ0CtpeK3YNO0L3LRTI2ios2vsTgs4tQfs5wnwx0tQKaMmk3TdBwQssGVCLpE+rGo1a2jAoJs3nErcBawZ9tUZ6z/h/4gEaIAwJwnLskCZhJf7nTAz6ojDK2NMG/MasPDmltOuixUs5C28PXKvdjfuqQ8D1beA7w7+szrgVDB7o4jvBlhZOkhlvWfhYGqKgIJCgyaiO4s3zdM/4k2VsqFMZ2Sd3c+BBw/JzvP6xT7MuhMbZZ4fc/1lW1z/W2v2yEZKAd4+jkiVBR36xBlQVXKNIwjVhYynxiA6i5fRgYEAifVnvpTDxjDZeJ210vSsa36vhHjR5wEvxG2zgYiz3HBK54zyEliqUOU//FjMCnFc+3b2zg615bKG3LwE4LF0JD5Y7NzFaml9g9LKMM1rL0diUq3gUuvvcxDVbmpEqROqWVwpH4YAetGajninK7t3KjYHc1wM790DBwmF+pJhuCf394v1il7cOoZRgr0SRrNPcQfvm+O7mAkkoetyIBq+r7bCoX6DDH9O6V/Kn6Ty6VXNYtGRtgERp6Y7oiMstPAwuJJetj0f8jAyWeY5da8YqgJ6HJ5BPnDB9TC9CH8ZXXnpO9cHYRBkgGLTjOP8ia1BFL7SLlyHCkNsyXZz15hZWWVOHc/uXOE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 pbO16c4KuIvl1MJOwWTvNQF3MYCok3b/wMDCh5YFpc/1fU+BtOs+ycm3v3usthYCeczLlkYyccMW+JGjmyPH5wpPB+fmdOVwkbZuTr5eMzc+vifKQpUmM8FKHSIRkB4d6JdBLBPLH8GA8mutt2W6dwpOE2MuLKWH9n/EPKnfg3wkIepw4WDhRPHLpLnOynxZBy7036MATDA9DeWY1tB7h50ZIDAcMRWXYCms+kzzlOYtE2wjDXnDFBJJXzKPtkCMz11yNR9cBK7KrwuojBHnD6GFD31iD1SHt44JczTCZrqMBdKJOeq/lBDklGFmBnQ1dIxO9pN7TifCDPalQqbe3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	17bbfb61-3035-4548-a9e1-08def4777d72
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|35042699022|376014|14060799003|22082099003|18002099003|11063799006|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	C0jJKJbIh8RXsJL+gJnciW/kWdZO+1P1z9YBvd2NQ1XCDLMPCnYzgGGe3Wu2VYIUjqrQ/mibbN7rhFSzbEtfSxrVDlmSgIQyn2RJk5s3O8cBrYyG/jCn9BkmKlg5JLwOLp4fsUta1/5MiisjFQWvZEXGkbfEZT7GNi3GtIJIl1Kl3NfKbh35tSTrJBLJsoRhugP1UXv3woQken1GcKPhnSZIOQmosqc4i0Ntq0/gg8pkLdbRu5Q2H+V5sXOKDbGZ08OnwieBSXaSGN/QhkErXkAVDzL6+0ndMYjRsvURUme63WLncxqJ8ZwbH9HB0UdrZlLtKeuEhjpY/Uxui57JsqB78qMQfedR1lj+qj/cQ3QDSsKS6hcc1H4edlxycacfGj0jX6mXKzkEh87tkGGrSeubSScGR1TJJtEcwnYO83vqHclgVoq1NKmjw/PEIk2pjEQvaMichBGW8WKYrSsQgVX/e1P11S3vwppXRlPnqkrHMA1ZNFKhR6R85g9omPyzkV+w4u9SJXq52zFpKn5fzM8CTIzwLHmundgP1XX54AQDjj2rj36rY2JGplhZEvaJrsTNakiSF3Me9bzKJhjD0p9DcYzAfrxIhRKTxobVys7jHSG+iZJxAuLojAFf73np4UcQMGrUgB17NPYwt65A4yHpHaMWWWTXI0Ux1lvvv23pvyZwwbOexx0TR6/7HI8aJRqAbYP0hJGmME2ggpKzoQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(35042699022)(376014)(14060799003)(22082099003)(18002099003)(11063799006)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O8ScK1jpOOaFxYqiJqsiHU5xnfrfGCj2VpZBCcU0SZwVAUk5GhDAsGLOKar+7yE3uS5gau9wR/92DeoJEp3C+aMOW/xix8+xna4eh2D9ofFDWDDdK0Nh3OFlIGiRKhGfc7w5Juz39YkEPGwzyAZ8phx9nkPTQF9c9egJ4aAE3dwR05/J4UB4BFAOdJrT04i+qUflOx/swdlR0q6BDOUApPmymKnTyYIIw7Nqh/tRl8dpYC+bEd6REHo6J01fpcGfh11E5+32p+4FkmfqzAK9YU3MHRMKZxGzBLgHyxIcZhtXh8SlQAoWZN1V+dscVCSp3Jxd0UPatXegyJ+132LwnJQ05UhHhJgj8Uf5ccl+h5dvtV0YYc0dRkXAEc+5g3h2/gUc5Vfve8YtZUeYV7hyjt2q6ZRQR7aDqR1PaTOx1x5trGZJAtBR62wspnWvtxju
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:32:31.8653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe182469-d635-4c36-c166-08def47791eb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7929

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 6dd3ff555ba02..fc400f4fbb65b 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -196,3 +196,69 @@ KVM_DEV_ARM_VGIC_GRP_IRS_REGS
     -EBUSY   VGIC is not initialized, one or more VCPUs are running, or a
              write is attempted after a VCPU has run
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs), or to restore them. A get operation saves IST s=
tate,
+      and a set operation restores IST state. kvm_device_attr.attr is rese=
rved
+      and must be zero.
+
+      The VGIC must be initialized before using this interface. Restore mu=
st be
+      performed before the VM has run. For restore, userspace must have al=
ready
+      restored the IRS state needed to describe any guest LPI IST.
+
+      Saving first asks the IRS to save and quiesce the VM so that interru=
pt
+      state has been written back to the ISTs. KVM checks that the VM rema=
ins
+      quiesced while copying out the SPI and LPI IST state.
+
+      kvm_device_attr.addr points to a struct kvm_vgic_v5_ist::
+
+        struct kvm_vgic_v5_ist {
+                __u64   spi_ist_addr;
+                __u64   spi_ist_size;
+                __u64   lpi_ist_addr;
+                __u64   lpi_ist_size;
+        };
+
+      The SPI and LPI IST buffers contain one little-endian 32-bit IST ent=
ry per
+      interrupt, in interrupt number order. Only the architected 32-bit IS=
TE
+      state is exposed to userspace; host IST layout and metadata are priv=
ate to
+      KVM.
+
+      The SPI IST buffer is required and its size must be:
+
+        nr_spis * sizeof(__u32)
+
+      where nr_spis is the value returned by KVM_DEV_ARM_VGIC_GRP_NR_IRQS =
for
+      the VGICv5 device. For VGICv5 this value is the number of SPIs, not =
the
+      total number of interrupts.
+
+      The LPI IST buffer is required if the guest's IRS_IST_CFGR and
+      IRS_IST_BASER state describes a valid LPI IST, and its size must be:
+
+        BIT(lpi_id_bits) * sizeof(__u32)
+
+      where lpi_id_bits is the LPI ID width configured in IRS_IST_CFGR. If=
 no
+      LPI IST is configured, lpi_ist_addr and lpi_ist_size must both be ze=
ro.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, the VGIC is not initiali=
zed,
+                   restore was requested after the VM has run, an LPI IST
+                   already exists, or the save operation completed but the=
 VM
+                   did not remain quiesced
+      -EINVAL      attr->addr is NULL, the userspace IST descriptor is mis=
sing
+                   a required buffer, supplies a non-zero LPI buffer when =
no
+                   LPI IST is configured, has a buffer size that does not =
match
+                   the configured VGICv5 IST state, or an internal VM tabl=
e
+                   operation rejected the VM state
+      -EFAULT      Invalid user pointer for attr->addr, spi_ist_addr, or
+                   lpi_ist_addr
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while allocating the host LP=
I IST
+                   or tracking pending interrupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
