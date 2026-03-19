Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013030.outbound.protection.outlook.com [52.101.83.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AB93E1D0C
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936016; cv=fail; b=TlNpDC5tdaDIYkIrZqxhwu3d1Yb8QfJzl4dWTKSy4wJTVDr/UFZ/A44UcKnQiO8ZlrkkT73+y9irnh1ZUAD1EXXVDyHaeWkgZQhbcMhF8JHu0kulpIVzvykmt8Hwifh/p85XgnOeOaZsMDr8qzP4GG1D2jb6L+PCzF+6xhuHmZw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936016; c=relaxed/simple;
	bh=ETz9emsfBVfXnRBcxNTO1j6W4mII5tgpoyFRRjnGH9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ca/2zaIfUhEdMwJe3pWFfI3A6upVsYSiQtZXKgqDh8nPe8RzryL7AvELWM8nxSfXCvuW3gONR2q2UfTG2omeSU5L7QwbFFgGvjgh7kyHUBMZVmHLoqvdpaiCsfcX80voa2//cY+ww+hPsXlAs4so/WSRU+Xkbf7EgYE49ewRXx4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=juZdmLIZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=juZdmLIZ; arc=fail smtp.client-ip=52.101.83.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="juZdmLIZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="juZdmLIZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hRbVfebkZn5ikD1KROAE7Us1DcDrqnr1jmhhs0epw+Jwy6z9bch+B7U9UVFTIEJ2UrGp4bzDCrmFnz0o23vo8Zggs2QSCvtEp3EoYjrmuUo9gBNYjNLNrZCtBnWiHFKf6LA/g+Yp79Cw4/6wyl6d+irlMN7ENHBGY2aWUCya03kP1giFzMlIbLMNgfINYPcRUR7YtOI+aX3JAa7EEjCT+VePx+5D18VsA7UahQLnGsXXSv3L4OEq6DPOsfOigBtorKpQrCseWkJLuuT/epkwrLFm8yW8jVSCAE++i/L2HrhhMWHSSy91usGkThmNN6b/2L38CzALHOXz+dTF6jYGTw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=DEYit6u7ShIeAxVCa8CrXsU6Z1VT55oImnWB5DP/7wfDLn2U+nb9e68Cdrc15J3XFMU7e+zkyRkt7ZKzEl41nQqBWOGRpgh3ZnJJWFfFn0tE5F+c+ISgjZNtbt47D7fYfaJoVhDgPoZnF9muNCqPpZghCibjsAkZSOjtBD5sTRUSz1B9gun9huKKgoQ108qMYSxlzvj/8fMhJwU3aqh3Df+t+DMJmAIjSUkDwdpIdAnz+7uvcd0x3xcKFjDaH9MMHB5XO2roCyG7VazUqWUABansMgFmDvoFAZmvbjnM8nf5pqHKZQf3peXD4mBO5rGkUu71NAIFx0YGXNwS8FsNrg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=juZdmLIZcwphdxZFsUGBLX65LbKCFwNK3J6MUYqSe4rTS+QoL2eZr+YbFe+dZ5+COdHxJLEF4zdDizu4rXxyCGiMBMGJ4i/B90oeUelNjIGn75aLwab9kJ3jCVkpcpfz73p3Zbi3y4+z2dnIW3HzqzhUYW2PLyMDhmEhQlxklww=
Received: from AS9PR04CA0159.eurprd04.prod.outlook.com (2603:10a6:20b:530::20)
 by GV2PR08MB11490.eurprd08.prod.outlook.com (2603:10a6:150:2a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:00:07 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:530:cafe::d6) by AS9PR04CA0159.outlook.office365.com
 (2603:10a6:20b:530::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 16:00:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 16:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/V1qmQ4PSnYAKdeseDmCvSUVigXs1EbAGm11zL47X8jLZ412jqi2mI8A585M2pBlrVYYPdDM9+yyl+awQsI86NTYVwXOkXf95Xl/Rz7kdxXF4dvdhQMEo77aN0DkPjRdtxMzzEhH27XxpIwas4YmX1lGBez3Ccm24pvKQMqcmCip5yDWTues8Ja6EphN1f0dROUCu1jbMEtePDo/IFj7p2xfCB0sUSrMMM/4l0k5ZdN+klxpKrow9+7yoM7JNjFoLfwQe7MozeyNoAwPtrVcajD7kE9kIvA7+6B7ZULLQQMyhwjqzc7weTSUO0vkkvL0EK97VdQWhdl3OwBfGHlrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=S4kZOiIWTAAWIHpxKQCC7e1SwIUHP4yvsHHhauOdi035Z0IbHbDMYcJLccNgUpeIqudwFNEzzTKxbz0vz6Y/KdUFw2tFurvxxV2Y5azmhmX3bp9JZ1CujXINGYJEzJgJWwuhlk5zAJLhA6eIKQsVOXu3PaatYMlkkth/Wl5NNsirfKggCO4GqceWhmDUp/sMPF7+clYLZRB1B77C9czp6cg6k+K3J/RjOGBN4Gu7jbNNxeuuAGuxorWT0UhPOqiO1uVrqoH4gksyUMaQ41KkCSvwoavq/48ymno+fW8SXThcz+LQuvJAUy9Lmf8rJfnPlRjvM205ghKZa8Ym4nreGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=juZdmLIZcwphdxZFsUGBLX65LbKCFwNK3J6MUYqSe4rTS+QoL2eZr+YbFe+dZ5+COdHxJLEF4zdDizu4rXxyCGiMBMGJ4i/B90oeUelNjIGn75aLwab9kJ3jCVkpcpfz73p3Zbi3y4+z2dnIW3HzqzhUYW2PLyMDhmEhQlxklww=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:59:04 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:59:04 +0000
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
Subject: [PATCH v7 36/41] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v7 36/41] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHct7lPOYs29Bem9kifFMAgGEDXjA==
Date: Thu, 19 Mar 2026 15:59:04 +0000
Message-ID: <20260319154937.3619520-37-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AM4PEPF00027A69:EE_|GV2PR08MB11490:EE_
X-MS-Office365-Filtering-Correlation-Id: 0993c33a-faec-4727-05ea-08de85d09748
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 w0rkOOBLIWsPmX0c0NJrBNxYewQme92mELjA70E2XojD9zKFi7aCPGKz5uT8h3lQdaezGHj03j8DVyESvl3OvBq6dZs3T/c6OSHU8+8WCTP7wGdk0nd0sbtNpfA+2I3GMGLh6JufrzSdgJ2s6nOJ9/luoo8Refx8wKPdBaQ6+hOqXxcuLQPWbBRh1+uE8WZODW5TRLMDU+2cWf4GO7ek1apNt5OEIP7Dq7a0hjTqeVwE8EqebMNh3XXDFHdkTX9xCsVXHcxefbF4NmSAzziCsQROI/UiWPLWTzniHxp3jFCaqunakKcv/x0YrulAe6mV5/2bg3dtfb/IEeNx8jyWu3XdTc7SjZ9m8KsnSWqvuJW/RLknCV7VpAzgAZ6GQ93Yml+d6a5Mg+DBJtRfZVlokOntjAlQVgb9tYrJHZx5BbWHks08X6C7Xtc1rz8A/Qqv0oGPqdiRItGKeU5c2YtEINj1bbN79dske0+rZRG3I9DgJYSPwqrNUJzwxYEylHvo0q4x9VGQ8fLWMaSyZaDvd6f+1XRIhhxfGT7buTA687kKyok/jcho4BOzgcR0BDOWaZ9+xR9cOMf9nI4bZHxizanEv5QcIREsxjvTyBRgNy4E0KQrQEMmDwpwn/G+z0GhB9h/gmQC1l7Y/WZxZwL8zH5K/7I/A2OQ6kkV95hRoun6tbWZsDvn2LTCybql6Ea30Bqxp8jsKrfJ73ulfKDvtbB4nAUZAv2caBZZPZJj01tXeXdswrYuHa8hZK2OER15QrX6L/i8megdNbaZmMQCvmSDIxDnrrYuZG2njCjV9mQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 GfIfrn27XHyHGIygT7Bt/YESuXk+h8Uiga+8l67p9qNUCoel07fIrV+uPyOw1MEQFNpFEp0ztDWwgfKAfbbhExrTOCRbfdH7vV63Ho7PbELyBWM/H3x6tHG2v/+p2u5BHMVXMoM78dpAPpFmke/hl34lpWkaXpDuf0zh7l3k7G8fuUv0UCuwCfIjQCwdHSlwn47h4TqmpyfHcObONhkgsfbbv8vdNrefp+DgInvvBdRBCQ9gB7+vekyZN+2exWFf3KJJdv694LxICKb69IUiivaYvvppW36+vJFSkc0dul1badwAjClsqQoQv3/OB6Vv12aZi5bLTsX5xCUALVniEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	66ceffa6-dc4b-4695-8bf9-08de85d071d6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700016|14060799003|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	l8Iue++P6doadA29iSDjhLS+xCR5MVwQhBPuNRXDUEdKGltORmJLK0b4FOf9togdpIZ+6Iv3QtGLzYl17sbU+RCt+RjVquXQswFNf9Bp4oQK7T3ICo+f/ddGL1gbYiyk/fkmosuczAzY21Ve3lSDyDSMzNR3E8y5S/VbwiPqs8cdzd0Znw2CR6D7L1PsXft4ioDUOmxguXuqmhb0OVoy94dVIULVuTyZPTLhUFelCf1mjrCi1LtkCgFGp1BDzpQToEkkGJd6ReU8eKEhiX6ZIY4VbVglgX13Zlf0ULUsm+RwLGNlCnPbi3uaqTDSZo32Y4iVykUk1HWYfXvfafqQPBeY7HS4KbVuf3Pqn3l4VElsG4a10g0Wz7jBf6VJo9XmeOyac1j+tSwTQ+FaysBjDI2MhnTTLarjfAnI5V1bevDhCGb4NhZH4GB+QGgTQPfLj0McnkSuVVQAdk3dpfS4dy+PgRBHjDEOKiCzDdJNIMtL6/Ufm9Umc6QOQyGUIZnnzIT6XX1Q/r3Z45hA1qk4B4hX1wnbdaBzGtXDab4zFsJZ2SoBMBx4WpK1R0dPmjZBMjK4VFLi4xBE5Xsr1iSdWL12/AaLMZ7joTnP+9fb7INpestvRUhYCO3JEh5pafvQRyDjMJkr5AGAUNQF4SuVN3cVSRirEY9Q3pigvCt+LUNR+3UYsCnaPuHWv3BW+Ox31H9Kj1ogV8LbEdiZhU5pjICEpqho88mJj5wUmG3qYgkRljEHD+KAICfYfbtRGv8zNCEHU82h6DNXQK/arOc2Dg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700016)(14060799003)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rznf49/uzsAAQd/JNWavLey79FN/FXGwv15Az60yPSHYLxC/p9wlog8NnqhbTXZhfzrXSdV4LVILtdZginIDzjkUbdZ2wvGti5WoSbb5btKFVvGfXPtKYKjn9tcKhqk6XUIV1czQxFvKxvVqrn+HC+cqJ1LDWkqljYEod+jPNOzRvS5PcpVtoXu5ePc6AllU66D8L8Cdw0MU01u5czRwzWHtkU5biJOLGaFi26wPiNad0Ziho7wUt+zZ2J67W6MoRlpE/YPhBa6qIERmxlme8Ij5SsuSMP13n3mXD2OTn2y75orhSyX52q6Fn8Qp5VLnLRgxKgroUifjVuODsAaUBY7EbgKTRzVMqlHnH+vK6ewhGB2AGw5TtAeTUX7ElI29cR1DL4UJaIY07KCgMFkoS0+I5KwWR/t4kiTt7o7MYpdlVo0VSIGnHv2rZiBCg5vg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:00:07.0028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0993c33a-faec-4727-05ea-08de85d09748
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11490

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 85f4c1615472d..998b2a3f615a7 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -248,6 +248,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1
