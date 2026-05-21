Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013035.outbound.protection.outlook.com [52.101.72.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D23342519
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375161; cv=fail; b=TzEQOd26gWjWg9KDy0AEY64/ysGc+kMhOGb4gNwErXxjkp/AmJV28YTFXEdiDdqkJ2UK/CEC1nGUudCgb72te2vshxFdOLbqGD8iMF8hFrHF8xCHJ0HvKY7odAXIN09P+jDJBzqHJ4nNwGV+xYlCU6u1cc0ZCNWaB8jbLaNobng=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375161; c=relaxed/simple;
	bh=vCXt/QjckaFJL+Z8JbjwkwgdZE82FVT1hVZjUa1McQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nasmCCJ4r3FlOKtfuw+Ypifji4P/8gPWI7ASyn9T2HL9meXJmZL+W7QWG5rK5t6//LiIrinp08uj1/JXWA4cEXbybAau84KO+RV+LQD4tvaggjlJB3f4NUQcGNkjvk3OuMXiU2F8UXIdnENMePHM286FK5WKbH+nOEamEcrNr7s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LyOF1byF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LyOF1byF; arc=fail smtp.client-ip=52.101.72.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LyOF1byF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LyOF1byF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=tlCe+E5OV4gr3IE8v3NwdnAIn28daujXMEcAOJJqvd4bm2xx0Ml9jiJLCs7qcl8Tt8MRbWH1BFmaVNReOFn1k8I3vdiHPn3q7Y0wtAW9JIbj8vLxr5DorhsvcynYVRf//pyuJ/6asnQotxyOIL5pRfP9sN6EyKFoj17+cNL+LpChs2/3IsjO1nusHZ91qcYBHVk7fqRBihFN69PT4EVT/BGGThof2uS9O2my0OLMzbfeACkN9rzN7jBrn71miVrLifxguO+imq6kGJORfYP492mONjl77mTqJJrXKV3bvz2X0Hy11+dHjUX8oDQ+uyQkn1WtpjUoc00EjXmsSR+sNA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=kRTuIW2liup7RBdK0DEIKtAVCrX7g542Zmn0N/bZ4xaU9mnOYqidxUjTRuW8UZGwh+Q/Zuz3EeQiq/GRSpLlD6bVxYQbe11h/E+H4zcU9cKEIASvziSud/VZXAnU2T40rzx96qjWnHuJJrfdisUIAjJOajriNufRu6k8/CqTpWyfmVq/6TQmnAWSRJNqDXMtQim+XKSAu6Tk/KxHnKpweSeg2T58zaJD48xGoJ1YaTFf+hbZ92yX9F4cZx24yOfhbG6XlJgP/CXMV9eggV7yAV6YUBtcrqSScj0YsVPzojS43yqJlHjpFz1X4W1ndCnOW5gY/X4Y+13vaC6eKjXd4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=LyOF1byFw36bcYiLe7ZYaq+Xx+SARZM6ziDC/Yg/YcdcqJi1FtUOhq3JwiefAQROjZCHVIRWSFJCtSuUwQhabqcTZEunk1P8wgf03l8Yta36q4HaXN1Xv2hVBLeoNwkksCsO3DhhmRs99fHQNyTuTdW6RhKbjDEPYArgEs3nn5Q=
Received: from DB8PR04CA0017.eurprd04.prod.outlook.com (2603:10a6:10:110::27)
 by PAXPR08MB6493.eurprd08.prod.outlook.com (2603:10a6:102:15a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:52:34 +0000
Received: from DB5PEPF00014B99.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::9f) by DB8PR04CA0017.outlook.office365.com
 (2603:10a6:10:110::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Thu,
 21 May 2026 14:52:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B99.mail.protection.outlook.com (10.167.8.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:52:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7hxBtk51Buy4JQC2sbIHUUSMtTe0x0YD1E+pi4C2VJf1P0sQqswpGavmw53HcGLU5iLVYzPMIc7OxxUYnggDeT7AVXYxswxks6GHrNWmJw69pv2EFcd/Tlwj7p2McT9Wm6BdtQ7eYfGtX1OPm187kVEDGC7iAbjfaUT7sL40O8eBdgVeEfnkBKU6YtBZTlhgAHzg5r498PzC83HrVZsKklJGjfbCbDfQ2tKp47eL/92nvC5Pe8BzKEZp0gZtUMSDEHtmy85Emp74fLOXvyUKST8YfVnk3HRkBQDPHoob1I4tK+MPp7dR0jJJh3gwhSJqW55ROhUKD32G6JOcIBAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=lgAioOASY+XDz7D9MHgCB6UlwvQofZ2hhOQj7GQN0Pf88sr2HK/7gLGJ0SWPavfzBfJpylG7CLirQ3ZT2ppXMtY3Cd90zEgYtmgIAfG1yEovAVMHomdqgY2W8fw6yMT1wcOIDc8ZID4F6uoMYohu2WiYULGTc3Q7kMoL+lzRFlYZX3srWGTF8IOu0ZsAUjV/qi/WoWI2GKZtvh26Cw5y183ZGcCWwg0ZAJKThK28Ol5hjSwPaIK4Q3qamwdLRYFnWooy2R8JSBGBQ2Q+cMwmpG/A4ZZEo/icF5oc2JToOjcigowG/BIavVerT2/D5p2jRSc0dGT+fySN8n3p11FWcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=LyOF1byFw36bcYiLe7ZYaq+Xx+SARZM6ziDC/Yg/YcdcqJi1FtUOhq3JwiefAQROjZCHVIRWSFJCtSuUwQhabqcTZEunk1P8wgf03l8Yta36q4HaXN1Xv2hVBLeoNwkksCsO3DhhmRs99fHQNyTuTdW6RhKbjDEPYArgEs3nn5Q=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:51:31 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:51:31 +0000
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
Subject: [PATCH v2 07/39] KVM: arm64: gic-v5: Extract host IRS caps from IRS
 config frame
Thread-Topic: [PATCH v2 07/39] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Index: AQHc6TFPGrneM98ap0ClgKVT/sEm6A==
Date: Thu, 21 May 2026 14:51:31 +0000
Message-ID: <20260521144846.1899475-8-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DB5PEPF00014B99:EE_|PAXPR08MB6493:EE_
X-MS-Office365-Filtering-Correlation-Id: 53aa41c7-0a1a-4a62-af48-08deb74897c3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 JetQJFeSkUNE4ASkZAvlpMRFRpT4suUNsRMHxY79GwN3jkmnIkOkMwMxY59hX3B8EpRmt3FlEHpbE9Wy+ZrvlMNzourOSTfo3GJhDLE5l+HJWQjghP0jdAta27riUGHS1J7xNjzRSCmNWaGLAe1v2q35qz3GKktaQVx7p7kOhcTyYDAlk5QshBjtuAB0oBHqlizCoidLUr7AVPaX0WPNgT1vRXFqHza3b8EUlRNgZrNEsUR9lUiWJKRP+9/xwa4n97GEYsAFd+jX6df1H72jiyOiX/oIVCR7Y1IRQph8aFWtEqSKOjf7sBQ3n53IEEJvOMeneknBL1FVJ+I2LE1O88g/1aVeoZcZzmiZ9iQ+3Qy3A/F0XOkf24+Rqr5kiXODCk6/u+oF/OnGBAv8OIJHlpLuyhhddk+UU2CDOXkRoXwmRi+tEc7Dix8PYZSVHe5OCbh3u3BzHSSqYf/IZw7397ppBf2aRmJLNb1Mp7PuLWhq+v63j0P7n6FXlF7k4nGWJaXeU1DuTLZ+ckhjegZCagSnxZajvKXbgL4m3BkcU8Q5LaEqnqkJTnZEMSljqwDe0suyf9CuFSPeN9gSVsxrPdKVImyuZ5LrQmxNWbMb6rZEkftlYKlT/EWvRh10LLujGaTdnDn99vo6MNcWxf4m/BV8QpRpJzclHX//oCk83XviQmQ156o9fb1D6DwEqd/CJkeUM6pWlwrxuBNfTkesLvpUWuctISOsMPx4LireR65C5qD6NUgXrNUze/Q2LyP+
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FJtcgv1B62qFsyeIedDqO9qeYo0Bv0NpRF1ENmwpy4oaNfMhIex/PUUdvaagylS0bN5Qv2+vHtxthIxktC0dJZjNHb93Z+Xu+mNSrU/cUKOKvKLWEkk4BUZ+/feAWuwFRqMjEzhB8Wzn37XFBOlPoQU0dPdUDYkGrVjQ+HEnfE4n/cjhjhiK/Y85eHB0Epe98gkSVs699pKGyi3+bakS5sXAcawCZEU4dhwWBt9lR3UGgPNwBCbdkmQCUSb2DbQY1J+JBLgKNcgQgtwboG+HxsVay3zu3e9OfJLiD9bQWSjhXaO10kczvgq7+JN9IjJDytRpG0vmrynqnn7DjkVNrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	950ca26b-10eb-4e10-1e3f-08deb7487265
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|35042699022|14060799003|376014|18002099003|22082099003|56012099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	vf7rtMhrfRh5iZjKIOwhsBOZ2Mm8/+yxfAU/4yM9dwcDmVjRI1B0owse9PFRo4zcprU1S5rMVTAo7E1731M2ClLWe722uWRKuMNwT9GRHI5bAXqSgU2OOeAbFlGLuyUIYF3bCpJlsqJTGSO6sUydCxWmiP9QlokvT44LTzUotv/OS924KGbsaK764/R1a9lhZEX17AmlBq9j0KisM3tbqT/Y2XoYbwAcZR6sNLjSTl8AVgAqGXd0Ob1xIY2zAhMryNKt0IHgg9BfiGNk8FSFo/r/dVIPN9m+wsXOYOA5HO79q38QB1aZ3iaXvStnvx+Rit8//rlZcyaFSp2/8/lGCnCrWwh9eUhxagFH8vgKNZyoOe+K/vBm96YALFO/5n3Q+Hcq2UmVeN6LHP0hy/A4Ju9/Rdw7Ygylthi5nFXKMIYGBwAZfhsJYDrJxBIekt7i0Z3XY5Hs0XaqGMvLX6CKSh3bzh3Xf5YeiKQQRj3JzwufBLxGbdqikbAyvOnmOk4qCqg9u6pQOeCu9O2b9V6SiaDRnSV6L9Y6TbTu3ibYaj3Up2aItUTLLVQGIsxYIEPMvxdx4kX+f5/QAL9JOFgvdEQZ6M8dV8sAciVicPGETNHm0An5HBhDyb3aBZiwInwXSIDO3RYXx8TB57CfLNNwen5okXUJjBiXt1y47EmKgxWLJgaI1BDaSoma8dubxpqao2PuB3zcVNVggO20E8zbODhnLQ4og+qPus8AkzSKKp8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(35042699022)(14060799003)(376014)(18002099003)(22082099003)(56012099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TMVgO5BsxEWX57NkFqig93qyItsCXt/HdVa1pfnDMImwY5j7dS+D1GOioceYNRYo3Eti5OB8gxB25iPXcclhjdJaj2HptVC9+1UjcqDE7JYyxO3yZT683SVg/Q6K57kk6CtjHePkMj60I2OKpJnO/d9Gn3e9TOhaMrMGu/OFS8PWpuyU9lo+8TGYip5Tx2rH/48ImZqUTEvmyDwo+2W20V0bEjpHGBQeRxhrVyWj5dXomNp9yZa4Kye9kjPE/AcdzVh5aGtuvCGnaOCROOFcRs9e6ZhOykVTvnsMvInW/x79LfkBDNo2KZZseGO+ZS2DbUNokfu8h5fgs6KkGtW2ux4x6N/U+8bfH/FfIjsG3GKeoE12pN9SfQ7o5pc/wPmPTRcXahz7Iax7DGvDUfXtlngXY6bBB62Ie+qDzi/eb9KAdcFC8QbcwGA7/BlB/LMx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:52:34.3870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53aa41c7-0a1a-4a62-af48-08deb74897c3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6493

The host irqchip driver provides KVM with a pointer to an IRS's config
frame, which allows KVM to directly interact with the host's IRS. The
MMIO registers in the config frame are used to configure VMs (in
addition to them being used by the host). The IRS's config frame also
includes a set of ID registers which describe the capabilities that
the IRS has.

Stash the pointer to the config frame, and extract the VM capabilities
(from IRS_IDR3 & IRS_IDR4), as well as the IST
capabilities/requirements (IRS_IDR2) from the IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 46 +++++++++++++++++++++++++++++++++--
 include/kvm/arm_vgic.h        | 26 ++++++++++++++++++++
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..3f7b132110114 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -11,6 +11,7 @@
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
@@ -34,6 +35,45 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
+{
+	u64 idr;
+
+	irs_caps.irs_base =3D info->gicv5_irs.base;
+	irs_caps.non_coherent =3D info->gicv5_irs.non_coherent;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+
+	/* We skip the LPI field as it only applies to physical LPIs */
+	irs_caps.ist_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr);
+	irs_caps.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, id=
r);
+	irs_caps.ist_levels =3D (idr & GICV5_IRS_IDR2_IST_LEVELS);
+	irs_caps.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr);
+	irs_caps.istmd =3D (idr & GICV5_IRS_IDR2_ISTMD);
+	irs_caps.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr);
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+
+	irs_caps.max_vms =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, idr));
+	irs_caps.two_level_vmt_support =3D (idr & GICV5_IRS_IDR3_VMT_LEVELS);
+
+	if (idr & GICV5_IRS_IDR3_VMD)
+		irs_caps.vmd_size =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, idr));
+	else
+		irs_caps.vmd_size =3D 0;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+
+	irs_caps.vped_size =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, idr));
+	/* Field stores VPE_ID_BITS - 1 */
+	irs_caps.max_vpes =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, idr) + 1)=
;
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -61,10 +101,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
-
+	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fe49fb56dc3c9..8d65a18fefb80 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -182,6 +182,32 @@ struct vgic_global {
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_caps;
+
+	/* GICv5 IRS capabilities */
+	struct {
+		/* Base address of the host IRS's CONFIG_FRAME */
+		void __iomem	*irs_base;
+
+		/* IST Caps */
+		u8		ist_id_bits;
+		bool		ist_levels;
+		u8		ist_l2sz;
+		bool		istmd;
+		u8		istmd_sz;
+
+		/* LPI only */
+		u8		min_lpi_id_bits;
+
+		/* VM Table, VPE Table */
+		bool		two_level_vmt_support;
+		u32		max_vms;
+		u32		max_vpes;
+		u16		vmd_size;
+		u16		vped_size;
+
+		/* Is the IRS coherent with us, or not? */
+		bool		non_coherent;
+	} vgic_v5_irs_caps;
 };
=20
 extern struct vgic_global kvm_vgic_global_state;
--=20
2.34.1
