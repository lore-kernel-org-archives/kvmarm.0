Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012067.outbound.protection.outlook.com [52.101.66.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88A73932FF
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522396; cv=fail; b=pgrseUj2Bz+N3RF55qBmkMeggWnM+cppOldgZM9CPG6+5DXG0lBlIHcdqiFF99Z3rYNv3d6hJoGFRL01qFt6T2OoUhCY5AaoYbLGXWvDrsNDHWXV0Q5Rb0u0qJUzQGEX/T1NCt2ada8cL7gFNLRI+0r+VcsZ5gnO6BJb5/EpmcA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522396; c=relaxed/simple;
	bh=XW+wheW4RqsBdlHInJFYS6jvDn8JrqQqhz/Jb0Arr8s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fYGOitUcTA5SmnVFHU8QVczJw1Q3B1SFdmcVevnhZANQwij4YYAjHIH/0PziVNHxAwxmxYDF50w8hWhSpUr50aF3/snT62WvaMkPYleNX4mZ1Hp07GnMaltNPCmhNcTRmT2N+MqTsHnWQRqAFMhTXcf4dnLGr1K9X06BGeKZDxs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LZu/egXT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LZu/egXT; arc=fail smtp.client-ip=52.101.66.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LZu/egXT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LZu/egXT"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=F4jnQoYGSGpPuhjr36wvngQT31mwatesSdKXfSWV9HAzEHl3I6ivHbj93fkHHLa/9N/qd+jrfgqOPmivlFot6Dsx90kRA22YamMRFHHyT4abq/kvXSfCNXQzLz+zs93rMlPn49HSu2VLVTzNA8ViIjMxI8dsclr/CsPorIccXXPs7Sz2bx4UgRv0dlpcivUvzBWaiJtKbibWwR2Vy74wXa0rwLpIgc54u2YK6wtQkHDjv3vBDJPBuoHR4+th+1zIkA1XTKS7bqxTmiaPcXpAaP0DQyOJyvGoiZG1QTsVFk7NFZDBjtY3YyodEb6DD5GmJHg2wP79EYCpYdK6J1+akg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axUKzXx7rYvPaCuIf0gd2AH4aGEgOwgMH74YnpSMM4Y=;
 b=S1VuJEAUYk1/NcWn8XiBCOkqJHfzhPLH89hotGpawpUkYKvMdWduMFBhq2h+q1pdm5E96978713rt5zSj4ltrnmAupmHAEufp+HJbFTotQgNzLG48+LxATAymxwgFP8TcKV0MWjfJ5vpVWIUPyezE3zQwizbkF7N1BccRDwOmBRtCABOJE9o4egiEKsN1/k5Wcda1ekGi8W+MgQuLyByXsvegky2JZzJXXXFl7duvFoEhEXD7Stxl1/pbbEFU2dPSaerHqhSGc7f00PCc8LRRkHGmsjeA51eC+5TYBW5WivYeTxZAmiNYXGERNz4tglrQ8W1kBNRLUNi4iVwkHLZ4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axUKzXx7rYvPaCuIf0gd2AH4aGEgOwgMH74YnpSMM4Y=;
 b=LZu/egXTk6QEPH258OqCApb2X5YZxmb9Nq0YS3ANphNlHKFitr9uQxeJW7wvOiYGJMQqGQ9IPo/bzjeuabXRHF8PtsoJnQUGc2JHSWPlX687UNjqOdfJNFShjc6GnP4edd6NL6YQAfFQgCK/cqSClyTe0tjHV5kVN3vXUzBZrdQ=
Received: from DB8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::40)
 by DU0PR08MB7762.eurprd08.prod.outlook.com (2603:10a6:10:3ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:46:30 +0000
Received: from DB1PEPF00039233.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::a) by DB8P191CA0030.outlook.office365.com
 (2603:10a6:10:130::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:46:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039233.mail.protection.outlook.com (10.167.8.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:46:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N94HvnWkldF5qu6Djt1Oxm3Xvz7i6w4Pgizy2Lc2DDtjDYQBkM9phJ/jruCF0Jn22HBlh6hzQ0aczl30HKB5RQ7V+7ok5uXr57APhNzNN5Qgo8JqMdPrngvY5e3WhZCPXP03wfY9Vj6KoTktMgSJf78NB3IV00ba4EM3VTQrLAptRhBXg4grTc52D5pGHEAY45qzV0zB7SCExlYYZre+GXik30XgeQZEGzRL9cwzz1VTLV+cM0lvH/YS2dGWGUzzoSEVX1GrU0RlaNX3gDFaPloPR+rMnixD/MgdwUneq0cnZbzPenwQkI+ii26xDC9RIdM5jcEJFiP/ihpGgUWQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axUKzXx7rYvPaCuIf0gd2AH4aGEgOwgMH74YnpSMM4Y=;
 b=iSrAjSV7vtQmBWl0nB7UZiQdgPZ3CD1RktlffbybNly9XgIjSnmdPyzYpnmx//Bav36UDCRB/wjNZOPtHQSv6gXbs4lKV6U7cPQPo1ENaAHNDSiG72Fv/Q0nQANFlwlQDV3/n6Z9YoYITQTTcqo2ZH++4l3MGIk/pO2lW09h7f3eN4abpCAzk/jTArjoi61whjqdhpVWZe0JqoRXQddnP6FCWyNqcddr3qGymEHBlxmbO1nDZ409Zg6AEUX5AWGeRoGnO5ioQ/zfUwhUwv3z2F8wTWt0ErKQTpz1dJf7SEYceOdrakEsghgJyJgHr8DmpPpQoCDKLiXlXAXQzQLlsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axUKzXx7rYvPaCuIf0gd2AH4aGEgOwgMH74YnpSMM4Y=;
 b=LZu/egXTk6QEPH258OqCApb2X5YZxmb9Nq0YS3ANphNlHKFitr9uQxeJW7wvOiYGJMQqGQ9IPo/bzjeuabXRHF8PtsoJnQUGc2JHSWPlX687UNjqOdfJNFShjc6GnP4edd6NL6YQAfFQgCK/cqSClyTe0tjHV5kVN3vXUzBZrdQ=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:45:57 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:45:57 +0000
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
Subject: [PATCH v6 23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v6 23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdPGLypr73dtOth0yd0acPAXRjVA==
Date: Fri, 4 Sep 2026 11:45:57 +0000
Message-ID: <20260904113404.4051341-24-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|DB1PEPF00039233:EE_|DU0PR08MB7762:EE_
X-MS-Office365-Filtering-Correlation-Id: 5447ec42-504b-4b03-b9e1-08df0a7a2942
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 TK3Ku/ApmYtpMu1Ll5oKPxbTNTN8nW6Cenzh7yLV6sM3RIoryNh5eHTZ7+8hfvHJEoK6DxW6E0BKABUoBteWXnCOAb93s4TbuQkY6LjhWXaSlWnuMv2buqEbcwpLzdXZbjw4aRSM8VxklxxyAdHUVO9AAmsVC17AlcmzRQ+sYXMV7fJgyw2zPyWe2uVjLog32N+PhjGrRQjqdlJpdIbQ9p6D2vX75DNvpnjKjMpeJUQ4911b5jhvZVyGLAeXDM2JHKvTBZeFturYpxHnCWUmHzVyLq95mXbeVlvCRUEJk3WGUUCZyeRbmVg92e06R2/DVAyOVkoNTqkWiKJm0KRELuqedgDJhP48sBEUkCk4AjzpNb2gJQY6WRh4XB4BSf+lUSOIoG6ADfoVuEJzMm5K8qSFdLnwwwFCYTiunDx/rkJHjWp+Q+YyD68oNfI1Vi5PNS5kE073A+LQg4yGc/OG4ZIlBr0briqU4NM/+dAOhH/s+MHKMqS26viVWnVwUf3PfuxYbOO8jmLr1ARsspV136uaKQ/7iPndp5RfFjVPneVD+ejQ9NJts5a98TRwgMrXmwb9aCt2gfvYvvYHvxjo02ntVuNT54DbCiwPZPz3ys4swblMRRWA7CKmzuamDAn8yzPle9TOOY1SKD4aLZhsCO237TmEFjindN2EJYq93Z6ffb/tEQwJJlgniBhSZdFeaN9D+MLI8TKpBzP17uYrG/em+Nj7JbNSauiIU4BRABI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 xGOUcUeA554Dm2gSYbzTQ+S1iI9Utwa/T2YCm7CkjZtbAcDJOivRV+roJxLEOWsPjw2k4C3FJS6MMfvG1KxXfDAMorGFNcB8fCBhG+MNpqBk6+NegZ4NFH+xBioDPZbVuJ0BkAU6o7vswzzc7rvbfax5WnBjCT6bANbbw62HG/vaVpJt+8II240inSjZTinC97lyaseF2jy13zisPDMfKdJNH9a5Uma6jkTale7zyy5EnZLScOAHvY9NO2DZnoHwgNdUAfb443v0zOc+rMGDjXFGK6MHl63MpSyewqMDswoE7raAWE6S6iw0ggaDvInui8JySTeIKguJwthgfVHEBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bc30ff45-64e8-4a5a-16fc-08df0a7a1585
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|376014|23010399003|36860700016|14060799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ImwmEyMi2s9QpMp9gZEDhOV2gqnVTjvb0bDI+FNqes6Z8gG+++FGBzJKR5xkk4g4cGUc0P9aBktmLn97GPKN3mPoocEMnf0sN2KWoKOwZoQ6veUqJl6slToxczcAmqgTq4kVJ4qLYayrDxycyU/HtFJbXzNnPDGbenBSP5ttEVsuEMQ6aCgXCBYxo5NsXWdQk1g4kfNJ0qCzsFcbQ2I9MCoAzo1FXDuH5jWXgdOuNNvJA8ilrWTE8ThhQkRYEvsEMJFRMS5cErLA25vKiDPF+6NKGUtUwpxnMRpETXRDus/qy4SdzcDNAVPrjW9DoybS8BTOaubfK2RAs31jFm+SyE8xbhm+XAJrpu7rn+e9FbrfypApaC9ETPD+xvQbb7H69N9ncC2bgKNAda4s31n4TvQrd1VK8L584lr3L+jFc3vnPg0AcPmX5aer9jUFEbuJO7EnoJo2EVh+LnDurAlXWIXGCDk8JboCdymNIemi98T8a9v7h+5DPbefIuEBIFbVbnpZTw7nOI30MpOOBBzlh2BDb/dTeWCYfoQY8R9fNOelF0qiuewGMRyhINdybzmdeKrwJDuTavVCMj22rVcfoJ92OI4Z3tb4BNi+Xb8lP4PdpMo3/MMpHCdOzotfOeZQCSfMTMfDNozKMV8gEL9ymClUdVDbhSb1neA8lcXAv8k=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(376014)(23010399003)(36860700016)(14060799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g7DpyDcofV5h4FQtJ4Y5khSl9IUTjkbOy7R3tljepbg1Epvjfyx6j6oWxPFJg/h2+TrJwQ+8EaQShyLd5TIbD+3lVt1Fd4QxIZiR8RXrA/vBLKwzPKXls9Mse6xZYID9a03TCVcajtybjan0RTCkRID0N1ke0t6WhFay4mKK9iBDNrQrgw5w7vKnvWJELRz578ctPQaO9FmkJ4aIGGx+FFPx0sronngrZbYfhWx+CIj6Lj2QCyJkQaF/lnGYP/1FGwuhLstcya9/30ZW7VtCVtUiqUaMIHlVaGf0/2YqCXDKkiHPS3ghSPdPhs8WaZcxT+YoIKVLak1J9HG+Dmf/2eafd6AjTgbtPMkRYjuBqNuVCdWBpQO0Xnd0dwEzr+y2FJsHUSinbRlMF6k20AUauCEIB97LBWNrd1T1BCIgkIW95dw3h50Xu90+NZVxbL+V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:46:30.3359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5447ec42-504b-4b03-b9e1-08df0a7a2942
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7762

The GICv5 ICH_CONTEXTR_EL2 register has the IRICHPPIDIS field, which
allows the hypervisor to disable HPPI selection for SPIs and LPIs.
Use this to emulate the guest enabling and disabling the IRS.

Program IRICHPPIDIS from the virtual IRS enable state when loading a
VPE. This prevents SPIs and LPIs from being delivered until the guest
enables the emulated IRS, matching the behaviour of real hardware.

Likewise, when making a VPE non-resident as it enters WFI, only
calculate the doorbell priority mask and request a doorbell if the
virtual IRS is enabled. A disabled IRS cannot select an SPI or LPI to
wake the VPE, so neither the priority calculation nor a doorbell
request serves any purpose in that state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index bdf06dbff4231..5a5abf51d4ddd 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1059,6 +1059,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !READ_ONCE(vcpu->kvm->arch.vgic.enabled);
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1075,6 +1076,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
@@ -1101,7 +1103,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
-	if (vcpu_get_flag(vcpu, IN_WFI)) {
+
+	/* Request a doorbell if entering WFI, unless the IRS is disabled */
+	if (vcpu_get_flag(vcpu, IN_WFI) &&
+	    READ_ONCE(vcpu->kvm->arch.vgic.enabled)) {
 		u32 priority_mask;
 		int dbpm;
=20
--=20
2.34.1
