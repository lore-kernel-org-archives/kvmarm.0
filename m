Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013057.outbound.protection.outlook.com [40.107.159.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF73438029;
	Fri, 31 Jul 2026 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509034; cv=fail; b=FQtMp1wmyzlFmMbBkyy2msIzUOZTY4SlYPt72LOuZI8d6+p/LDgGStquNWydA4KgghKPbUOUVymmGD4xImzlw3JdfjL2y7sIyHsjeUO4rzdF9sNR6oI9mborN2128/PiV+V+oOA/AsUejVqaUV0V7vqZNzQLIYYgyetvZEOKnLQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509034; c=relaxed/simple;
	bh=5o1xqwodHBZl7hO3Midayk1npBsv/Hxa1IN6NMsrtPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VObIvLs1TOdE6hNW3wUdctwYjGQKdbJNmrs2xtHmtiC8QR99ulHdFhNvrVDEBEsn02D1tO7goGg1k3vblCggNIDk3qIeasL6Ju+W4OxqQJBB8Ayl8RDJ/SRuVrIbYquxTMLmVJgoROHeeWRz3Ptl7vwBF0oYTWhjrtujsgvadxI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G07qbkzR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G07qbkzR; arc=fail smtp.client-ip=40.107.159.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G07qbkzR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G07qbkzR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dAiuLHDoG3OP6K3DwOo2yfO5U4R7PdjDWc7lFYX7VuZkFs/DWd6BV2giOfty4kkJNvL1WrQf8f7BAxU1OJlPVdVY6y/6uLljKA5aBoXWyGJvtixaiP9GTB7ATg9ozBfH2V022O4wfZp3lZKUH5JAuwJgtJOfXfvP4Jq0XwAXtFqqRjMVe7hXvl8CTqNdLPsObRy/F3ttU1PxF9vwNyZdUR97q+Y7+bUDFZcaeLq+rwygi9ULrVqU5dn9ljx3tYHflipimHUkPuV6FrQpd9xGhYIxy9kGPe53oXk9IyzaXsL6QW9bHFOJ11PnbJpOwZXhkYLAFIk3K82VnA23Rlav/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o1xqwodHBZl7hO3Midayk1npBsv/Hxa1IN6NMsrtPA=;
 b=XZ/jZ7vuAQwLCpOhbe87w4a0x6K9n7hQnCfxjT8CyDkv6uz/rpDf0ek/jsx1jGyXjwSGRzYQPo03QfG/A1cL7MzlisCwet7sCv10/YfKm5QTLlxMpqG20Px1WvKfGPIdMMmB/gsByV21LdNqaRwNAyhoWp/3sh5wRmAcm2j0vIkizmJC84pnjYonCCAwCibrnyCEdoW54lDd4iUczPQykToNVeaAblNLc+yEc8pFQcQDSPN2WuPQAlxGdwNFGUutcRwsLkRc2YNIxiH4oropuYVr7glaE7XGCQlBsDaSrcTzsuxXvOP0gh+SdmtojYtSyq6jK0J0Stpv6pbMn9589w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o1xqwodHBZl7hO3Midayk1npBsv/Hxa1IN6NMsrtPA=;
 b=G07qbkzRIBwhtyJqlQ4FYK6gWibazbBec+Poi8JZRedLIqoLEiHkWZtZjr2vUc3ZHBQ+bGrXdjdZDBKisNVv7gbH3ncNHhUtf0L1Tx6iE6CVcxJCbJQv840vfoBzG5EoMNERJUo1EsWvB4Sk01KD8JGQKLLP3J9vSJEjmxxQ0jA=
Received: from AS4P189CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::8)
 by VI0PR08MB11083.eurprd08.prod.outlook.com (2603:10a6:800:255::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:43:43 +0000
Received: from AM4PEPF00027A61.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::84) by AS4P189CA0016.outlook.office365.com
 (2603:10a6:20b:5db::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A61.mail.protection.outlook.com (10.167.16.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:43:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mOKFMFSJNBo5Oo4PHnh2UPOc6f7gYW7OX4IKh7K+AydWVhr9LEifv19E0bhNV6ciGSGVVVhMojbk46942zav+W3l/sFoSNM7LFmFfPLDmacXFDPmFc+y7+S3mlRpXzV85UqmdWLldgSk5Qe3Au/JNbcXbTUhMqBCc8R1elzW/dOW0JhLcEWAPRGvBuosN8oS+zl7/EP78eQd10450GdWVQUFiBIQ0zmw1rHL/9zFi/RtZxrjT8Iec0fPK+wfn/ka11dk38Xkyn0f2wIrqoFDH8cLpiEFHll6dY31YCkq9m5N+XscsMcsoiss3t3QFd5tZT9uzwCHVL9pYX3SlOS2/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o1xqwodHBZl7hO3Midayk1npBsv/Hxa1IN6NMsrtPA=;
 b=YmbV+TqO+uh74BnutX9hWK2NR8R1XFqCNooRMido/z0kooz+CJ1xIefHKqyXPbqHsAPue1DQMZnLRIy8u+DTnxBd5bvtb0JZby4fWO3ZYzzduOBSMahlzKXth94wWY7u3K2m64B2rRBw9mXvp8lhOrfAzYbaiFgQxi18NmMS0xZxTrSc85bR/2nJz8LAfIZ1pwqDC5O6JzsXiPrPFYnzBwXNvemX0wPzSMf3hRpelukzedcHnPN6mwIsgaTqgesTCZhvXvncfnm5o96trpM/VRoqPgv3yBaZg8rpj/PPflND9Rc8eiotyAU/1wjimSoGk3O+29bYTwgZEIdjJ7J4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o1xqwodHBZl7hO3Midayk1npBsv/Hxa1IN6NMsrtPA=;
 b=G07qbkzRIBwhtyJqlQ4FYK6gWibazbBec+Poi8JZRedLIqoLEiHkWZtZjr2vUc3ZHBQ+bGrXdjdZDBKisNVv7gbH3ncNHhUtf0L1Tx6iE6CVcxJCbJQv840vfoBzG5EoMNERJUo1EsWvB4Sk01KD8JGQKLLP3J9vSJEjmxxQ0jA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM7PR08MB5525.eurprd08.prod.outlook.com (2603:10a6:20b:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:42:39 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:42:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace accesses to
 IRS MMIO region
Thread-Topic: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdG1saCJvLbaHg20qHU528QFxbuLZ8ktSAgAssHwA=
Date: Fri, 31 Jul 2026 14:42:39 +0000
Message-ID: <361e646b580635bfe4f54240bcb0cb610b9ef384.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-33-sascha.bischoff@arm.com>
	 <20260724120552.6CDA11F000E9@smtp.kernel.org>
In-Reply-To: <20260724120552.6CDA11F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM7PR08MB5525:EE_|AM4PEPF00027A61:EE_|VI0PR08MB11083:EE_
X-MS-Office365-Filtering-Correlation-Id: 07d55621-5c15-4e1b-9f5a-08deef121e3b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|10067099003|18002099003|22082099003|6133799003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 ZXvJ0xMk6Nrhfj9VJq6/EsMTck2zwl9BPdHuw2f1fMC8I0d5dGShs3PiOx8zgXCbxWFl68VTHJumfACXV28+6JmERvVva09i4pgCFb7DCmwHeQWR0t3/tkDe+q74rMaKWdAT7+F68aD9ZFfXSrXoM4RR5WwIXTwFWJQl34E4tfBgupAEPsSBhwox7+obCrny3AUq9AvL+2JAK9WoKijIPFJklc+rQA9Sv46FmTJwec+4NqxJjQRwBW7+vJO6XA/g5MhwxIK75LeB/sMLAJCkzxVhHyFSEzTsZj8BWFvUAz8EFue+YTRm9ZiVXEiiv0j8HAdES4BEWD5Uf6wk2JUVUODI7oJEFr1mlSFj10THsqqN9BDrplzIVX2H9DEqkUneYGUJD3a3o5vmlR4kzpo4uJ8r6kRc0vBVdy3jLNQlRJPPv8J9lVO4JoQ2HmmeEq7O9qS/3ySWdTmKIj+TZCrt+gvT7Qv+0ubGH27tilSl9TPszTWmKWWOKPZlt18Qo91mbJ69lNVkfmmDLKvrWfnhrQg6v2c4U5701Qaz3DvgqB3I54VncGzvFc49B2R/CjkTfkXfMx4jbgIqzqC2VHBwK793wUmM5ZdHnAn3bVYa16CKFZ1KZHVtMjQZWkkS3Fn9K4RbqPHfQXtajo+BaDqM/j9JBZpR7weuuBDdgerx2vK7izWUC/dVSHaw7T7oWVgoyoTKfaJZbJZmC0aqIMPHeoYegmb+Lziqj5cNGP4tgVE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAB0B7CB17AF8D4AB00772FD264C7FAF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gbhN8+sFFHPBI67RsUOVvxOcxSnoseLrO4eN0IkQ0p5J50Ohx1B8iqIZDbHfqFJsmJUvt4m+gm7QGkAGjnBMCAXxl3zy75snCjCk1AmSawK5qVjhRAG9GUW5AuK7NOW3Sf+mPeFQC4zPtrS1ZGc+o318997aEHuOJdl+TbcEXdApi0MtfR7p+95bj0poA9Zz57cIvHWlRY3sl12MX0vppLXUvJavyIqVjZWTU6siKQV7arqSHHFJulIXv3nfF4aDu2y9vg4EvtqZD/VBQrqet0kPmTgj64qEiFHXcSKtcPF/QLa1HKvVWbF9czPVHfofz4S3iSVOs6tKoPhKS0+kfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5525
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e8e7acd0-2f59-40d6-cdcf-08deef11f85c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|35042699022|1800799024|376014|14060799003|11063799006|4143699003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w5STqcidozhEPn4YeuPoV2KRmA2U5h3h/COUjqKFcRa+tVCRswdPR8ROfZX5luN4h9XQrFgM5V4DYxPP3xxs5my5RYeoW95N+ta8LFisE9b8k2tkemZISZni/q//djAr39OweZcdQMu2YONyryira3EDEL6t/CbW2NDCaBB9DiM4t+MpBqs4SKGmj36G1+tWTU4z8UIFnPRy7wLm60v+MazGRmMumf1a8cIxndY8UD4jdxewoL76r3g6mxO1NO4X2KzwBDGhYZCzqoCr8WcSfjM3uhEqgbfEk2k5UUm6liCMMXttRUJotAsm8fw+5/tu9Pr0fWIh603sOM96Kff0wOCBzTZDkmzWZHgDuo/X/5yYQToLJTo1ylOPZG7E8maVhaHWanWx7zDL8dWBDnbD2SFFRr7Mtv7cQ4RcwS16/Mp3S1XaDr2fdEoTQqYggMJdlJ64MXWV4R71POzzJGqyB56395p/8h8ZHr8VHCZ31BON5h7eAtrQ/9Tss/046x1qxy2T8PJEKxV0xBFbVr2Lla8Y7bybmkoL9AFVfEosSTjWCsltQdHNdhIH+lWLLOkIP7dCIUJ8m24IG/Z5si3tZXrtxbix6YH0Wt3o0ZXEJxbo+/N538IB4o1WmzTvyw93WlzlliKTQNXYtVhqnYMA0jkJU1XXGsvVk7N8zBS0jEoiu/is41UxOkL9n8obIC6cJyP9a9sF5uMU6jsZOavILQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(35042699022)(1800799024)(376014)(14060799003)(11063799006)(4143699003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KvwvnyStYZq29eAadzFWacgIOBAglXlp7vNfzK2VcpXsz5us/3yn1lcm5hcbPU02FuapIKUJ1mfQDJyVGz+Z5oDVnCrApipIQ2PNuYirO2TB+q/pgPilNwq2ZqDi6XOy3VVkSrecngyY3CZeMslljcY1ZtfqF3Zhji27Y67f/lKxg7R4a+CgXBLznoKLJ2qS5f+/Oun26iL8OZYclLtQf+DPVm6DcF+72s5wtw2XagIIilxlOpEBeQB7cOzVqKl/bhOSs22swSK5Z4fykTKCXbwpH+OCvFujwa7Kn5dU1xahkfDpKlVZhhAVA3xZDVbpM+/vWx7MgEMuF7JpX5wIJqYBas3qzyAn+JA5W/jsjG1BD/L9WifHOkDIRN9CeherLevjLHgs3f6KZ2NlsxQLmJZAsvs79ML7ktcaC4mlxqFbw8olMvj7/XXWDWtpgw2b
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:43:42.7853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d55621-5c15-4e1b-9f5a-08deef121e3b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A61.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11083

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjA1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVXNlcnNwYWNlIHdyaXRlcyB0byBgR0lDVjVfSVJTX1NQSV9DRkdSYCBhcmUgc2lsZW50bHkN
Cj4gaWdub3JlZCB3aXRob3V0IHZhbGlkYXRpb24sIGJyZWFraW5nIHJlc3RvcmF0aW9uIG9mIFNQ
SQ0KPiBjb25maWd1cmF0aW9ucyBhY3Jvc3MgbGl2ZSBtaWdyYXRpb25zLg0KPiAtIFtNZWRpdW1d
IFRoZSA2NC1iaXQgcmVnaXN0ZXJzIEdJQ1Y1X0lSU19JU1RfQkFTRVIgYW5kDQo+IEdJQ1Y1X0lS
U19TUElfVk1SIGxhY2sgc3VwcG9ydCBmb3IgMzItYml0IGd1ZXN0IE1NSU8gYWNjZXNzZXMsDQo+
IHZpb2xhdGluZyB0aGUgR0lDIGFyY2hpdGVjdHVyZS4NCj4gLSBbTWVkaXVtXSBLVk1fSEFTX0RF
VklDRV9BVFRSIGZvciBLVk1fREVWX0FSTV9WR0lDX0dSUF9JUlNfUkVHUw0KPiBpbmNvcnJlY3Rs
eSBmYWlscyB3aXRoIC1FSU5WQUwgaWYgVkNQVSAwIGlzIG5vdCB5ZXQgY3JlYXRlZCwgYnJlYWtp
bmcNCj4gZmVhdHVyZSBlbnVtZXJhdGlvbi4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMzJdOiBb
UEFUQ0ggdjQgMzIvNDhdIEtWTTogYXJtNjQ6IGdpYy12NTogSGFuZGxlIHVzZXJzcGFjZQ0KPiBh
Y2Nlc3NlcyB0byBJUlMgTU1JTyByZWdpb24gLS0tDQo+IGNvbW1pdCA5Yjc5NjcwYjc5NDFhNGM3
MGMwMWM3YTY2Zjg0Y2JmZWNhZmU3NzU1DQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNj
aGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTogSGFuZGxlIHVz
ZXJzcGFjZSBhY2Nlc3NlcyB0byBJUlMgTU1JTyByZWdpb24NCj4gDQo+IEFzIHBhcnQgb2Ygc2F2
aW5nIGFuZCByZXN0b3Jpbmcgc3RhdGUgb2YgYSBHSUN2NS1iYXNlZCBzeXN0ZW0sDQo+IHVzZXJz
cGFjZSBpcw0KPiByZXF1aXJlZCB0byBzYXZlL3Jlc3RvcmUgdGhlIElSUyBNTUlPIHJlZ2lzdGVy
cy4gUHJvdmlkZSBhY2Nlc3NvcnMgdG8NCj4gcmVhZA0KPiBhbmQgd3JpdGUgdGhlIElSUyBNTUlP
IHN0YXRlLiBXaGVyZSBwb3NzaWJsZSwgdGhlIGV4aXN0aW5nIGFjY2Vzcw0KPiBtZWNoYW5pc21z
DQo+IGFyZSB1c2VkLCBidXQgZm9yIHNvbWUgcmVnaXN0ZXJzIHRoZSBhY2Nlc3MgaXMgaGFuZGxl
ZCBhIGJpdA0KPiBkaWZmZXJlbnRseSBhcw0KPiB0aGV5IGhhdmUgd2lkZXIgZWZmZWN0cy4NCj4g
DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnMtdjUuYw0KPiA+
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+ID4gLS0tIGEvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLWlycy12NS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBAIC00NTUsODQgKzU4NCwyMTcg
QEAgc3RhdGljIHZvaWQNCj4gPiB2Z2ljX3Y1X21taW9fd3JpdGVfaXJzX2lzdChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIGdwYV90IGFkZHIsDQo+ID4gwqAJY2FzZSBHSUNWNV9JUlNfQ1IwOg0KPiA+
IMKgCQl2Z2ljLT5lbmFibGVkID0gISEodmFsICYgR0lDVjVfSVJTX0NSMF9JUlNFTik7DQo+ID4g
wqAJCWJyZWFrOw0KPiA+ICsJY2FzZSBHSUNWNV9JUlNfU1BJX0NGR1I6DQo+ID4gKwkJYnJlYWs7
DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBzaWxlbnRseSBpZ25vcmUgdXNl
cnNwYWNlIHdyaXRlcyB0byByZXN0b3JlIFNQSQ0KPiBjb25maWd1cmF0aW9ucz8NCg0KWWVzLiBF
eHBsaWNpdGx5Lg0KDQo+IA0KPiBUaGUgY29tbWl0IG1lc3NhZ2UgbWVudGlvbnMgYmxvY2tpbmcg
dXNlcnNwYWNlIGZyb20gc2V0dGluZyBhbnl0aGluZw0KPiB0aGF0DQo+IGRvZXNuJ3QgbWF0Y2gg
d2hhdCBoYXMgYmVlbiBzZXQgYWxyZWFkeS4gSG93ZXZlciwgdGhlIHVhY2Nlc3Mgd3JpdGUNCj4g
aGFuZGxlcg0KPiBoZXJlIGp1c3QgZXhlY3V0ZXMgYSBicmVhayBhbmQgcmV0dXJucyAwIHdpdGhv
dXQgdmFsaWRhdGluZyB0aGUgd3JpdGUNCj4gb3INCj4gYXBwbHlpbmcgYW55IHVwZGF0ZXMuDQo+
IA0KPiBDb3VsZCB0aGlzIGNhdXNlIFNQSSBjb25maWd1cmF0aW9ucyAobGlrZSBlZGdlIHZzIGxl
dmVsIHRyaWdnZXJlZCkgdG8NCj4gYmUgbG9zdA0KPiBkdXJpbmcgVk0gbWlncmF0aW9uLCBwZXJt
YW5lbnRseSBsZWF2aW5nIHJlc3RvcmVkIFNQSXMgaW4gdGhlaXINCj4gZGVmYXVsdCBzdGF0ZT8N
Cg0KTm8sIHRob3NlIGFyZSBzdG9yZWQgaW4gdGhlIElTVC4gQXMgcGFydCBvZiByZXN0b3Jpbmcg
dGhlIElTVCAob25lIG9mDQp0aGUgbmV4dCBjb21taXRzKSB0aG9zZSBjYW4gYmUgYW5kIGFyZSBy
ZXN0b3JlZC4NCg0KPiANCj4gPiArCWNhc2UgR0lDVjVfSVJTX0lJRFI6DQo+ID4gKwkJZmFsbHRo
cm91Z2g7DQo+ID4gKwljYXNlIEdJQ1Y1X0lSU19BSURSOg0KPiA+ICsJCWJyZWFrOw0KPiA+IMKg
CWRlZmF1bHQ6DQo+ID4gLQkJcmV0dXJuOw0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+IMKg
CX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiDCoH0NCj4gDQo+IFsgLi4uIF0NCj4gDQo+
ID4gQEAgLTQ5NCwzNSArNjczLDUwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmdpY19yZWdpc3Rl
cl9yZWdpb24NCj4gPiB2Z2ljX3Y1X2lyc19yZWdpc3RlcnNbXSA9IHsNCj4gPiAtCVJFR0lTVEVS
X0RFU0NfV0lUSF9MRU5HVEgoR0lDVjVfSVJTX0lTVF9CQVNFUiwNCj4gPiB2Z2ljX3Y1X21taW9f
cmVhZF9pcnNfaXN0LA0KPiA+IC0JCQkJwqAgdmdpY192NV9tbWlvX3dyaXRlX2lyc19pc3QsIDgs
DQo+ID4gLQkJCQnCoCBWR0lDX0FDQ0VTU182NGJpdCksDQo+ID4gKwlSRUdJU1RFUl9ERVNDX1dJ
VEhfTEVOR1RIX1VBQ0NFU1MoR0lDVjVfSVJTX0lTVF9CQVNFUiwNCj4gPiArCQkJCQnCoA0KPiA+
IHZnaWNfdjVfbW1pb19yZWFkX2lyc19pc3QsDQo+ID4gKwkJCQkJwqANCj4gPiB2Z2ljX3Y1X21t
aW9fd3JpdGVfaXJzX2lzdCwgTlVMTCwNCj4gPiArCQkJCQnCoA0KPiA+IHZnaWNfdjVfbW1pb191
YWNjZXNzX3dyaXRlX2lycywgOCwNCj4gPiArCQkJCQnCoCBWR0lDX0FDQ0VTU182NGJpdCksDQo+
IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gU2hvdWxkIHRoZXNlIDY0LWJpdCByZWdpc3RlcnMg
c3VwcG9ydCAzMi1iaXQgTU1JTyBhY2Nlc3Nlcz8NCj4gDQo+IFRoZSByZWdpb24gZGVzY3JpcHRv
ciBzcGVjaWZpZXMgb25seSBWR0lDX0FDQ0VTU182NGJpdC4gVGhlIEdJQw0KPiBhcmNoaXRlY3R1
cmUNCj4gbWFuZGF0ZXMgdGhhdCA2NC1iaXQgcmVnaXN0ZXJzIG11c3QgYWxzbyBzdXBwb3J0IDMy
LWJpdCBhY2Nlc3Nlcywgc28NCj4gdmFsaWQNCj4gMzItYml0IGd1ZXN0IHJlYWRzIG9yIHdyaXRl
cyBtaWdodCBiZSBpbXByb3Blcmx5IHJlamVjdGVkLg0KPiANCj4gQWRkaXRpb25hbGx5LCBpZiAz
Mi1iaXQgYWNjZXNzZXMgd2VyZSBwZXJtaXR0ZWQsIHdvdWxkIHRoZSB3cml0ZQ0KPiBoYW5kbGVy
IGluDQo+IHZnaWNfdjVfbW1pb193cml0ZV9pcnNfaXN0KCkgaW1wcm9wZXJseSBjbG9iYmVyIHRo
ZSB1cHBlciAzMiBiaXRzPyBJdA0KPiBhcHBlYXJzIHRvIGxhY2sgdGhlIHVwZGF0ZV82NGJpdF9y
ZWcoKSB3cmFwcGVyIHVzZWQgZWxzZXdoZXJlIGluIEtWTQ0KPiB0bw0KPiBoYW5kbGUgcGFydGlh
bCB3cml0ZXMgc2FmZWx5Lg0KDQpSaWdodCBub3csbm9uZSBvZiB0aGUgSVJTIE1NSU8gcmVnaXN0
ZXJzIHN1cHBvcnQgMzItYml0IGFjY2Vzc2VzLiBUaGlzDQppcyBhIHBvdGVudGlhbCBpc3N1ZSB0
aGF0IEkgd2lsbCBsb29rIGludG8gaW4gdGhlIGZ1dHVyZS4NCg0KPiANCj4gWyAuLi4gXQ0KPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWt2bS1kZXZpY2UuYw0K
PiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWt2bS1kZXZpY2UuYw0KPiA+IC0tLSBhL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmMNCj4gPiArKysgYi9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMta3ZtLWRldmljZS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBAIC03
ODYsNiArNzg2LDkgQEAgaW50IHZnaWNfdjVfcGFyc2VfYXR0cihzdHJ1Y3Qga3ZtX2RldmljZSAq
ZGV2LA0KPiA+IHN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgKmF0dHIsDQo+ID4gwqAJCW1waWRyX3Jl
ZyA9IFZHSUNfVE9fTVBJRFIodmdpY19tcGlkcik7DQo+ID4gwqAJCXJlZ19hdHRyLT52Y3B1ID0g
a3ZtX21waWRyX3RvX3ZjcHUoZGV2LT5rdm0sDQo+ID4gbXBpZHJfcmVnKTsNCj4gPiDCoAkJYnJl
YWs7DQo+ID4gKwljYXNlIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTOg0KPiA+ICsJCXJl
Z19hdHRyLT52Y3B1ID0ga3ZtX2dldF92Y3B1KGRldi0+a3ZtLCAwKTsNCj4gPiArCQlicmVhazsN
Cj4gPiDCoAlkZWZhdWx0Og0KPiA+IMKgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiDCoAl9DQo+IA0K
PiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gRG9lcyB0aGlzIGJyZWFrIEtWTV9IQVNfREVWSUNFX0FU
VFIgZmVhdHVyZSBlbnVtZXJhdGlvbiBiZWZvcmUgVkNQVXMNCj4gYXJlDQo+IGNyZWF0ZWQ/DQo+
IA0KPiBJZiBhIFZNTSBxdWVyaWVzIEtWTV9IQVNfREVWSUNFX0FUVFIgZm9yDQo+IEtWTV9ERVZf
QVJNX1ZHSUNfR1JQX0lSU19SRUdTDQo+IGltbWVkaWF0ZWx5IGFmdGVyIGNyZWF0aW5nIHRoZSBW
R0lDIGRldmljZSwga3ZtX2dldF92Y3B1KGRldi0+a3ZtLCAwKQ0KPiB3aWxsDQo+IHJldHVybiBO
VUxMLg0KDQpXZSBtYW5kYXRlIHRoYXQgdGhlIEdJQyBpcyBpbml0aWFsaXNlZCBiZWZvcmUgaW50
ZXJhY3Rpbmcgd2l0aCBpdC4gSnVzdA0KY3JlYXRpbmcgaXQgaXNuJ3Qgc3VmZmljaWVudC4gSW4g
b3JkZXIgdG8gaW5pdCB0aGUgR0lDLCB0aGUgdkNQVXMgYWxzbw0KbmVlZCB0byBiZSBwcmVzZW50
Lg0KDQo+IA0KPiBCZWNhdXNlIHZnaWNfdjVfcGFyc2VfYXR0cigpIHJldHVybnMgLUVJTlZBTCB3
aGVuIHJlZ19hdHRyLT52Y3B1IGlzDQo+IE5VTEwsDQo+IHRoaXMgY2F1c2VzIGZlYXR1cmUgcHJv
YmluZyB0byB5aWVsZCBmYWxzZSBuZWdhdGl2ZXMuIEFzIElSUw0KPiByZWdpc3RlcnMgYXJlDQo+
IFZNLXdpZGUgZmVhdHVyZXMsIGNhbiB3ZSBhdm9pZCB0aGlzIGRlcGVuZGVuY3kgb24gVkNQVSAw
IGR1cmluZw0KPiBlbnVtZXJhdGlvbj8NCj4gDQpUaGFua3MsDQpTYXNjaGENCg==
