Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011010.outbound.protection.outlook.com [52.101.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E303E9F9E
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935982; cv=fail; b=ucksdzx+KAN6My9tVvJxAjMv5jviFIiW8fysJhGMwi7DDjGgGFl6bAw1PlYAL0nU2MD2qOOqFcmJ1ouxXVtALYCgtHvoUk9YiJPFlkUokNApa9Xug4YvYCGFzo3/k0UOySorVNRrcsVc0mkpiG7LflRDUkMHdOq6frB9rB7wFWw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935982; c=relaxed/simple;
	bh=CCVutuJ3JdlVBKLMMymBjba1YBzLeDL7YIR7GNFl78Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S6RlrMWaJHvEsjPjnCuDx7ZbnMaSw6xJPqpxzwonNFEbJI45zPuaGAm1ZwxQSC0bGvOM3agJYc702AzD6L6wh1A21mZbq/olxiGCNR34F7LL9VyjeYdFO6qLmJeQfqfLARTDTyjS3QMoYW+9ek0Y/ndDq/uVrD99rVgjboCtlG0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NjlRYeYZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NjlRYeYZ; arc=fail smtp.client-ip=52.101.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NjlRYeYZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NjlRYeYZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XcryIS/Z5QbAbwoINeF24Rq1o+L3RycQiDjv8EOGz6J0eSCcHPb3i1M3cijEXmZG0h5ecdt5DmT+4Mn1OmuDk0k1/HqvPZZ7UwdLLKWAdIUgdGfSSS+iyQz4298+Bn213qrwRkQM1eSYrCeHje8ti5VLfJoTWwJDVeu2b7fT+hBrkw7c0U1DV7mCnTj3eJ0aRa0hCDGQtW9+NU8L5+n5V7J7+1E0A5HnHPTPBlCx04gElXAhaMRSF3HJtfrpGT2U6VoRIohafhmD3eVIyk+mtwbSS5qiG/4YosHZvExcfJgGHqD4vMVVyBgyhE8G864TL+80SNGNIQh56V1ZMyeahQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzxZx3q9nMsKM6rgg6T0hPYsDDjSnOVqxEMJivyuz1A=;
 b=YaspBnoTocVI4VpLYzJjgFfy2Duelfexgjg+Hss38VOd3jrQe9RpmLACj9O4+1csHjsX6Xyi1oWfyPPKsacPhdsHdROsXdiiR+QZjJZKYI2lomHwq5G8WYhnS2VcTf8USyOl2wiqx2Hf7mjJ5H+fFtl73dQdF1aJTJn+5ngKcJUl8AT2cndZCvE+MqRXcMj7DKOi3e/u241ke3vTKq60gZNdKhVr629BvrEqM+VZ/tIQoEOZQhFZSb3T+T+fizjFjh+FIxh0K/H3YLJrvPsfL2fW2oDp7hMSiv5yOUWhCqdUhfGtRNTY2BOdAqyT11Xd/4rwqlA9J0Up5KaQNWOiTA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzxZx3q9nMsKM6rgg6T0hPYsDDjSnOVqxEMJivyuz1A=;
 b=NjlRYeYZy0Ccz9r3mY8v7wLjOzb/KDsgwgQq2qxep538yBtatd39Fn/ODq/Z1n8lVVZByzrJIBEqlN0qUC4BCJY89rpAe2sztCG9snbcm089WDy6UEF7v/BKEV0fXdya7JmE/qLYqNqqKWbBj8aX6Ilf97f2PX4zOE5JPdm7ibY=
Received: from DU2PR04CA0080.eurprd04.prod.outlook.com (2603:10a6:10:232::25)
 by PAXPR08MB6413.eurprd08.prod.outlook.com (2603:10a6:102:de::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:59:23 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:232:cafe::87) by DU2PR04CA0080.outlook.office365.com
 (2603:10a6:10:232::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:59:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvOXWekYB3qVEV6S3ZYTFKzXWAiCROmg+dsP9yK+kXaTOyGOBvNLslJlRhgI4ej40McIn2g6NtTZHcyIGlxjg+mtt1j4kqEoGqFx3OQsWNeiV9XIR8BwlXGevsQCvp1ewxOA5CxyYwgEO5KeuIwVkL4lfvP9cxfgao16iv8e9nstMmUxCUIeQPSo4xvF6lKtpcJ31OsSvmoGiVxLqUUoVHhEkPO8saWI0Pe9PZAUDt4XL5qvUsfYlwP2OONmDQWJQe8sVOre1cMXExyATFUEu2WyHk6AgUQggGEsF4FzKp15gMmuvSWRfN1KRyWIIvwJhWIAjs6RaX9XFpNcRSruYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzxZx3q9nMsKM6rgg6T0hPYsDDjSnOVqxEMJivyuz1A=;
 b=BTq9GWpmiLCyLmbf6tF7bbC7JShAbqAq2NhRfYeUhF0zzpJauacKjbkkkM1CKsqfRWVPTb5tDtEqmhBqpNikWizBUuqIr2XKmJghi8gmZhauPlqRR+5Dc5XZ+AV5LI62itvrb7FkVNhGZs+8sMAogRMgLW+R0OJTa3/bN55TabEw05Z6VgRQZ07HClKkjGifyXjBjPJWF7DOVIIi5hJPR6t9F0EwPMBTYYgSTkYU+Wq+/JZlX4cGAmswfA1e/KBpnfyKBtVUqJTR7sWUskXCAuZS9yX4uEgXnhTvQ7wiSfr9WblI/MHkGrO4wFJkDsoGl+No1Fu3ITxFDfwqcjU49g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzxZx3q9nMsKM6rgg6T0hPYsDDjSnOVqxEMJivyuz1A=;
 b=NjlRYeYZy0Ccz9r3mY8v7wLjOzb/KDsgwgQq2qxep538yBtatd39Fn/ODq/Z1n8lVVZByzrJIBEqlN0qUC4BCJY89rpAe2sztCG9snbcm089WDy6UEF7v/BKEV0fXdya7JmE/qLYqNqqKWbBj8aX6Ilf97f2PX4zOE5JPdm7ibY=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:58:17 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:58:17 +0000
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
Subject: [PATCH v7 33/41] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v7 33/41] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHct7kzoxREuFIo8kipG//6STz3+w==
Date: Thu, 19 Mar 2026 15:58:17 +0000
Message-ID: <20260319154937.3619520-34-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|DB1PEPF000509F0:EE_|PAXPR08MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: e019e4ab-0ec7-43de-d5d9-08de85d07d30
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Ht7Gme6gXF3pVRseNuAFbCcgc54FJ1f/bZQWP4CJW2OMDu7p582TqEgwUq5L0FUk1Mf7r9cd3ciQPfv2BIWcmBnkSYgSXuAVxQ6IbGZ3XfI4ET7lt0FaphFl80Fvc9kGxV7EoKIoWlLFplXKOTxKFyn4V9DeQPFDX9VEp4xIZcizFpuGxthVnrzWDge6wDGutYLM57oJRGLGhu18c4OCDXVIg3SViNGOGsZO5UP7UAF9zHjxNw1mSUGiM66xztcZkPkxXTvFBrw9i7HFld/tkn9zROQJhj7FW5BYYgvIHIkWe/Hx5qeNSUqtbIwBl8y3toGF+UPfM+HYpkfRL8h+cMSdGtg/GN0uX2roRtRHfbnXOSQVNXucMrmR6tMjQyHDNGAL5kWqCXc9DaPZQ0ibQM6BBz/+wya8nvtsPk4ePcBs6G57kWVh3beU/gW63mD9VWPuac8LGSz3bdF1wmjx7GTzsK16Vqyvrh0nGUGq+FoQijYjWIE2DoxrUOzB2l9/9W4Jbhzx7Vd/lRpzlookMVkk0Bz4nQzkHP3cP3uMwAPJzwo97VjlHlXQdTYwuK5C2R9az58jdmtgWYCOR1QtqPtvh9nSVRjWrg8ZZ3/4XmuAf7P5NPZBbYVK9bqIXcyGzaV8CCpm6vyzsAtl0OitJaQyrjDUIMgVosFm8pzObRkxnZw3Pyh9lWuT+LG1BgKxIm5LxE1MhvkRGW4ufJ7vO5qYkIGUKXNfaO347FHd5ThelMzluAx/dum1v7kMrYlaEjAVJpJ+RHHIrtUalFzyldgCN1UP7qZW0lnLQyer7ts=
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
 trkWhQO24XLVi8eFxmdH59treEP+TcfyQrkqHhsq2lvCQ1aIG/oDyUnjtdvp6a/OaHMQZXEyYQ2dLOyGIjI3XYG8jWqvfJ3BIuFNBOFWQD4pPboDrIeRiBXQ7dVxczszygVtfDqozDNdldzLQr5BM1PsBM+00bApTbT4V1+x5IgV30a64wPYjnqwPqnBrLaMmLb8IBuwiLoKkZoAjkWJ+/WDr/f4d9DM6P4u8oO+egEotZW/A5PTYcGaEm02Sf69jnAh5W2F/bxFQPIu3rYYn9On8GnKIN+TGJOU7Z7M+DNMBM76Tycyp5UMRDK4o0F/dLqd4I2Wq3lKANUKMJYC+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f0289779-b8d4-46e8-37fc-08de85d05609
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|35042699022|36860700016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sy7oq+Ky/hqT208kz787IpfhP7pKlkglA0LzwN5uxsUyxq3nDOd4+6uhJeMFgcNigQDNq52C2oTbqVsjvqYGE76Jz2upp8JfyO1a1W160RykBg4DR6/fGwfDD5NhMI1mWo0ZSj87h1Pm1pnPLUfvchYhBRl7J6ezCh5MjON8dIB7EbQOasJxzJ/tmeCRMvK/HOARwFObPUDRuyRCsnUX+d6KZCTP6WQ711Eb4A2SRGaa8BWVJl84OygNWuh2ruHS05Cnr004S8B7t5iUltSykDAA2Il01Km1P9Aohe0v/r8+6w6hZOKB3tJbv3jRUcNF3gNpN0RXApemEQvH6BRqTKhxQtwvvRBoeojFYqd14gNtr5/9FxxVKtW1MReYU4wNqPv4d681hVkxQvVPMqirjkhLWukPKm4UTdbtcaxYpA6WQksTgnUJL8zXjy/aCwqvWTd9O8DN4q2/KRsQ0Lux143jhyEwS5T6euo41eNTIw2e0knQTPF9aZIjzVzCf+Y0V/NXmi+MsoVz6Lwjox5CHElzm5EnY4wjjTzAbGjYWysMaWvWgEtyYr7ZelHIYE8OZQSbce3/hS8mqG8e77Ew4PAXYrl613tOPORJ6M+xc1RonXFZI8TjM0QGvWGY1wj7J0Q8q9T/AQ89He2BtT0XQxQG9btrK2UcoXapYsEzfzU+OVmV4goLb523bkjZ55L8y8KC0iezWKW+HRycSDWHgkdUKc/jz1poxFOcfWYkzMBHXEyCjVZQa7FfcYvjyvJw3Ax7zq253D3ah7Lg109y7Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(35042699022)(36860700016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nwr02nSaHaCGYrHZ5+ewWPBUhgd8nMVT1vto172wji1D5muSCR7ckxuAPuPIAL/jgApI0CmLij87/b/LcLXdqZbhbWJkFq6ZUfnTQ/j5bJLFVa4EW+MFhtMJhNrwfYRxgprZrKvpvCKpmzjx0uJhU1xU2kVtGxJtSxgwR+DKMjUd9uvdjaFiAN48Vv1/PSArywTNz8OT4SFqYItqcKCtcXyg+dfIL0i9jYyAXiArSBpGLAZriRhSDYYhu9AfMyrDx0GyKr5Z0M/8hsXgJlHu926ECEoxpnebXA+vqdAK2OCw10HuE5rd4B+ynJdVoc8k8z94sgdW0uohUOjz9UgHspnx5kcmeGTNDgiruRASk4voA08oQXHy3IyaGtKoNabTuzIZq8uvPGImWWRrFAORGhtd/eQBYoPJshmJjAByWjsRGkXR7HN1QF/qf7CmQqh8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:59:23.2193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e019e4ab-0ec7-43de-d5d9-08de85d07d30
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6413

We don't support running protected guest with GICv5 at the moment.
Therefore, be sure that we don't expose it to the guest at all by
actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 2d8dfd534bd9d..5648e8d9ff625 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -145,6 +145,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b28ab0efde2fe..05a2c1ed117dd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2530,6 +2530,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 06d28621722ee..b40fd01ebf329 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1
