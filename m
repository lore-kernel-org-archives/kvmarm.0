Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013055.outbound.protection.outlook.com [40.107.162.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B203C29E0FD;
	Mon,  8 Jun 2026 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780923584; cv=fail; b=cXNFPjxFuuBPgnQGAb3bvxWNVtxTfliWk0QOHeKCLfKoIBvQiPmv7xqD/CoqEqqGz1ImLxNbz/tnFPu5Wx4GO2UesgMTVhh+u9ZI7QRBmf2o8Us6gFOGaIwCrOc5v439CW4fxpHoGbmHFMko9UYDob/GfzFMF4AjT0XfHCNJF68=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780923584; c=relaxed/simple;
	bh=CB1yQ2WRBkfmmmSSlBgPeQN7ghfoOJYyffHp3gf5b4w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RfUJiIwkTVJcDXNvJEkc6GxxxNrTlnkcTxFiBLtOLPy8HccK9WTnfg991HwdiG/PfQHHDCYqqtoUtLLCdYQR/+hoBmsJjp8kvqux+1H5Nuc5QVKgwcopAfyzsm7bToijPxj8B2AaxzUdZWR64oeaDXlxu0b3BTe5/ubq/Do6JFM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oiCgokSY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oiCgokSY; arc=fail smtp.client-ip=40.107.162.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oiCgokSY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oiCgokSY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sixcleEOC/mSGn3iF38C29XEVB30KshOjw3I6J2e1PCeCL9pe4rWtrNC2Q9zmvFGAVOXN6KYs47dXuUJfM1GzctQCOlKMC5+mL4YCKAFrJ7oFNjWC0C/MkVa5KyxAwHGxlCzuoPUKNbvcnhJnvtn+X4F+LTik7zX/+izlM43mvxc9YDWv5SJCc4Va5K8PSi7ke0uoGkeuw5zQy2o/bqJsH56DlEsdO6cxNbBdPx9Ecbagck2Wz6RVyOpd2xJbN8XVqhETdJ8jTCZm9yUDMMo+vSy03gJm3gIkOG+phGWwPBlTzX1qXCpcQTKMdSy3/82gVnYZumkI7FObz79+DJJeA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czAJKt5uCbtoAWFp9bjWXOYPCLzG0qz/KM//Y5Q2Ius=;
 b=hIlP7Zuj8nFhLJ2Lsnw0ohYQXvoLupdG1JjNhVFw0wwUvzHRrUh6bLOZ5r93t5aAYZXDIcOHpioPfyzWY6JnoA5Pims1iHA6CVuSt5Xiv3ijCn/8oE2Qw6xUUQipzaseUtTazmx8/C9qKjn6rVHuR5mw/n6+c99OWwsPElJ4YC25BRaTC9IchkmgzyT/MNnqgKGRKSnIVmRjEOO3TXKIIkDaYiBhuiiRh+4RsnH99FxbIituDjIsM3+KexipkLaVSONX2ydF+xpuaza+vJu9KNpnSuV79OnZ+FY2awlgYWYF3tBvkzbErBVv+iqbi1GesCPEadao0PyFWjdmdj0BTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czAJKt5uCbtoAWFp9bjWXOYPCLzG0qz/KM//Y5Q2Ius=;
 b=oiCgokSYjt7zDI8E4cTKJszrrOmbWbEXRSovwEEmMflvyWqafB9QVef8cLsPdx2g32sjib24TyuYx0JjKMEr9tx1Me/YlHbQaGavfIyWDUB91hhkQFYlV+AFqd6cidQKQYp1LYxe+40Io5zFaykA7/AQDFhjSGlqqoWB7Esu3vw=
Received: from AM9P193CA0016.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::21)
 by PAWPR08MB11557.eurprd08.prod.outlook.com (2603:10a6:102:511::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 12:59:34 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::a0) by AM9P193CA0016.outlook.office365.com
 (2603:10a6:20b:21e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 12:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.7
 via Frontend Transport; Mon, 8 Jun 2026 12:59:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sOoUUT6r44gTEat1epLeojDqy5/AjMyZJMZtHNIHsVXHvtNMb8++9YFakAO3xgyYVRUeg6L7Xd8ScT9IVYywMAQYWvLhMiGnO/MyTv6YMeyacjcLl1XyW3qmWECxYyX8m8KwaT8/NncqdNK7HFOicPdEQfSM7R2B/CI7Zzx+f1h5Pv7MGZbFzcO8Pd0C6KOujg+FwOR70yERfJMIVNfBCrYxUzKhYgKPTsohkn/Ut8y8O4NUvJF0uLQil81zEqnuaPQrYbnuXziYzTWEoPSx17U+0Dv7TmsGTKhOGTgqJlxqHFS6fC+kKb/8iOElYLMrtOr/JQPGJLAX8MEnVEsnuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czAJKt5uCbtoAWFp9bjWXOYPCLzG0qz/KM//Y5Q2Ius=;
 b=lCThMZZ9A0qHdhQbJHdKexok3HDYqXxlq5QSi7T0BWqac5QPMDB58ivyOQrYS/ubtJzDOA//DUQPsVbguYbz5Gi3t2O0OlHHw6r9QDKqXbwK+JDRXbkQcHAM8ylf+YXmoV1eTo97Gf/+vExyjkhrs4EcY49o9QaWfFi0yYBwpgl65DVrPshutTMfK2D+KprqCksGusmw6n0Uyq3B85HS8HEcmSCxjEj1y55BmnlEJkHOEiLfwFt0LYZ5ZSte9MSXC4UZ5BhbwnsptuNeBAtJPT4mngrnZu6tDHlWSAr7GJHf0V8LduW1M1m5ZEFpZajgmtnxx/hsuUh/ix5eHpSiQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czAJKt5uCbtoAWFp9bjWXOYPCLzG0qz/KM//Y5Q2Ius=;
 b=oiCgokSYjt7zDI8E4cTKJszrrOmbWbEXRSovwEEmMflvyWqafB9QVef8cLsPdx2g32sjib24TyuYx0JjKMEr9tx1Me/YlHbQaGavfIyWDUB91hhkQFYlV+AFqd6cidQKQYp1LYxe+40Io5zFaykA7/AQDFhjSGlqqoWB7Esu3vw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS2PR08MB8830.eurprd08.prod.outlook.com (2603:10a6:20b:5f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 12:58:24 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 12:58:24 +0000
Message-ID: <06bfebdf-5698-4a60-aade-2b74c796fca3@arm.com>
Date: Mon, 8 Jun 2026 13:58:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <cecbd148-5d33-49c8-928f-572f71b3dd69@arm.com>
 <21abf014-a68c-49b6-a113-4ec59c520a30@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <21abf014-a68c-49b6-a113-4ec59c520a30@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0025.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2df::12) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS2PR08MB8830:EE_|AM4PEPF00027A6A:EE_|PAWPR08MB11557:EE_
X-MS-Office365-Filtering-Correlation-Id: 96c64cce-8234-40fe-aafa-08dec55dca3e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|6133799003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 Zl8biRku4jfh7ac5PKgyd71seEIzKcss4DZm0UG9BXqgDtMxwFcWl1uqITUuAxThIRDi8QsB1+A0PqKSbAY+KAPEaVLNN+PlMXxtFy6H8ZUzNP9YqyMU7EZR5PefG3xCKNrCrDE1CI1fTOA8UPSEf8eSSYX8kb26AvvrWR8MnpbN+xOVa1vh+cYSoY+5fDant8uvroMf8tO92J4tkPqV6Ha8oSiSgPkU531LEM4wl21z2pecKvCnngP5xyAA3bPBVWYV4SHi3VPeEw9bGz5qfX8csWsGeWYtu1ZJAP2nC3S3sbk//yd5ET/dxPKosQ0UINQ/CMcaccx31jOclszUMhpM2+jtN3DxOxzMphAmRyuPfRMgUITwQpKBdluFGT/LyCszZ6EOBv3BXGBiZJb7U5xotbXq8+ZgH2PqBBksKczwMBSzN/5D2ixidQi7FkXtgKha+MNFzaJMC1qKKYQt5U4GhJcBl290TFMmWcwFniRaRE1YQN3/5m1hlPfx4XYW6v1r2VexsJLiHuYMCTbNtmAfR3sOjbzlQMJY+k0x60AyBerLnLJJPIPynY2jwoQaYQ/AGfCveoULSF1j+ElNrOB8wSOYeT37lqdAP0GQmwn75ccZpeWec12FOEhdg3IeRuJBHJ0qg+d+1iSkPwU3yRI3TCwTeBTVb4gusayOf/++Z+xzMgSuJVG9rFxp1HmS
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mQLC4hDPvs9gDjdlHA3U/9LHTv8YbjSqgm/DfhnZIGGIRzNpHRvEkWq/jxVO8N4cIEWsQqPcCXm2XyPp7HrxhiO+1udQXNu4yTrQfm9aAMP0D4jRDzciRzsm8SHm8IaqftP+1IWwGnIid5vsuyk1zVO47Dc2+G7I+uhrk+PcM2lJ2W8BLpAkio5QKqIxyieZ+KJGjrE5M0c1nnz0M5ZbkbIs+RWctRk+q0JNh3UecEl4moBCyo5CjgZw0nVrwdM/sgrfXQ++6K96gjcpNqH5m1vz1gpKhWKFiyTN7u7lP5t6WdiN4RidFeFD7pj90l0ffUuDAgA5woYzXSAljK7Yag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8830
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c4342021-90eb-477e-424c-08dec55da053
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|14060799003|376014|36860700016|82310400026|35042699022|11063799006|4143699003|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	xHB5lG863/DCw4ygkHir7tCsT0nRsnyVox81+GYm17Mc1TZCYlLIwm8jUVTngX92J91LW9JHrNS++ClQaGtG0EfPKrmFGk8jat6QrbeBA0YKUXEPp+955K5Jc7ABKUfRMNa3eeK2Y0JDsySt+Tg0c+b5zvdkB8D1MOFTmeSoUBW+X+YH6+NPW4n3n74Zzp5sgeHhgYdd+ZjXSwDIB71Geh9WTT9gcV7WjT8bj42K7b3Mljib0kJJWsLJ2s5JuvcYVXj1HZbrejsN+cC/H9QVAih1HqLR9zwp3F3IiYUr+6FM48wsOpqsAKm/m9opWEudMrmwxs49ruuab62ZFj4tX8gWY8F/VlmUHz2KaWYL25mDvdoDlD+20/vr08mBAynYB8nTrmuE11t+yOWTP1aqSFkKX7zakgf1CoIQ9eDfNFnsvtkxoVunaZtN+yX++PIpWkW+xvROBBA5fNu0epabA+VckqTalBqCvxoLk57Kkmi6QOq3OD1e9RXLuJfqPfKswJy78ehskW41+qCsfbkUxduVMfUSGyXfQ/aVzpW0qyzeKEwtg9pYuR3ZMCV6tFGEv/Qj017gR0J7Rydk+8fbK9T83vOWVniidRjrK0LNShU8gtBlQzc31OmcYY8MbXHf/4YS8VL0RUkfAKVUgiCHgKBvhhuybPG/6EC9IPPb6LMzFbBa8Ns1k4RuOvXkddDg3SAeroHvUN6rYTv20dxpoJGyGUovzi5vNLpX5f4ArT8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(14060799003)(376014)(36860700016)(82310400026)(35042699022)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EXDSwdzcg0PrUx7KiP/dt5g4fNgM03hcIo97yBn7iYUY4OuGSOmEm76hGP/ccfXbQBBvd+dMpLzDAdMcpfsQcoUrxYcT1ZhfTj6aK/BQK+FhID/PyBeZIWvmIgoxLb74PP470wZP63hmomXd+nir3YTeVhTBRJN2YcB/byLVb01ZOEWdpFZQE8XfFL2OJouKm9CzU5qTzMdZcMGcmAJpu4PzcEjAayulsftMY80Wr6eLYt0qcA8Xb0q3oxjbpWRWNUxJiuUdLzRibfTbDtUrXlP4w6olG5yXSJafbsXyV8VZsdMnKqE4EsHs+xIt5P9WmNxmcRUAJsPcm9PDQ7dUZW02Qtd3Tl1ysg20mxKMYUlfLU7aOdCf8vgbQ8kSWK4bH1LPZIjqk8Ed1kljBdmvMo0ibtE5UCoulvQesGsyfE0nvClRrjPZklFSN0vJGP9k
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 12:59:34.7923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c64cce-8234-40fe-aafa-08dec55dca3e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11557

On 08/06/2026 11:56, Steven Price wrote:
> On 08/06/2026 10:30, Suzuki K Poulose wrote:
>> On 05/06/2026 07:23, Gavin Shan wrote:
>>> Hi Steve,
>>>
>>> On 5/13/26 11:17 PM, Steven Price wrote:
>>>> At runtime if the realm guest accesses memory which hasn't yet been
>>>> mapped then KVM needs to either populate the region or fault the guest.
>>>>
>>>> For memory in the lower (protected) region of IPA a fresh page is
>>>> provided to the RMM which will zero the contents. For memory in the
>>>> upper (shared) region of IPA, the memory from the memslot is mapped
>>>> into the realm VM non secure.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v13:
>>>>    * Numerous changes due to rebasing.
>>>>    * Fix addr_range_desc() to encode the correct block size.
>>>> Changes since v12:
>>>>    * Switch to RMM v2.0 range based APIs.
>>>> Changes since v11:
>>>>    * Adapt to upstream changes.
>>>> Changes since v10:
>>>>    * RME->RMI renaming.
>>>>    * Adapt to upstream gmem changes.
>>>> Changes since v9:
>>>>    * Fix call to kvm_stage2_unmap_range() in kvm_free_stage2_pgd() to set
>>>>      may_block to avoid stall warnings.
>>>>    * Minor coding style fixes.
>>>> Changes since v8:
>>>>    * Propagate the may_block flag.
>>>>    * Minor comments and coding style changes.
>>>> Changes since v7:
>>>>    * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>>>>      internally WARN when necessary.
>>>> Changes since v6:
>>>>    * Handle PAGE_SIZE being larger than RMM granule size.
>>>>    * Some minor renaming following review comments.
>>>> Changes since v5:
>>>>    * Reduce use of struct page in preparation for supporting the RMM
>>>>      having a different page size to the host.
>>>>    * Handle a race when delegating a page where another CPU has
>>>> faulted on
>>>>      a the same page (and already delegated the physical page) but not
>>>> yet
>>>>      mapped it. In this case simply return to the guest to either use the
>>>>      mapping from the other CPU (or refault if the race is lost).
>>>>    * The changes to populate_par_region() are moved into the previous
>>>>      patch where they belong.
>>>> Changes since v4:
>>>>    * Code cleanup following review feedback.
>>>>    * Drop the PTE_SHARED bit when creating unprotected page table
>>>> entries.
>>>>      This is now set by the RMM and the host has no control of it and the
>>>>      spec requires the bit to be set to zero.
>>>> Changes since v2:
>>>>    * Avoid leaking memory if failing to map it in the realm.
>>>>    * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>>>    * Adapt to changes in previous patches.
>>>> ---
>>>>    arch/arm64/include/asm/kvm_emulate.h |   8 ++
>>>>    arch/arm64/include/asm/kvm_rmi.h     |  12 ++
>>>>    arch/arm64/kvm/mmu.c                 | 128 ++++++++++++++++----
>>>>    arch/arm64/kvm/rmi.c                 | 173 +++++++++++++++++++++++++++
>>>>    4 files changed, 301 insertions(+), 20 deletions(-)
>>>>
> 
> [...]
> 
>>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>>> index cae29fd3353c..761b38a4071c 100644
>>>> --- a/arch/arm64/kvm/rmi.c
>>>> +++ b/arch/arm64/kvm/rmi.c
>>>> @@ -597,6 +597,179 @@ static int realm_data_map_init(struct kvm *kvm,
>>>> unsigned long ipa,
>>>>        return ret;
>>>>    }
>>>> +static unsigned long addr_range_desc(unsigned long phys, unsigned
>>>> long size)
>>>> +{
>>>> +    unsigned long out = 0;
>>>> +
>>>> +    switch (size) {
>>>> +    case P4D_SIZE:
>>>> +        out = 3 | (1 << 2);
>>>> +        break;
>>>> +    case PUD_SIZE:
>>>> +        out = 2 | (1 << 2);
>>>> +        break;
>>>> +    case PMD_SIZE:
>>>> +        out = 1 | (1 << 2);
>>>> +        break;
>>>> +    case PAGE_SIZE:
>>>> +        out = 0 | (1 << 2);
>>>> +        break;
>>>> +    default:
>>>> +        /*
>>>> +         * Only support mapping at the page level granulatity when
>>>> +         * it's an unusual length. This should get us back onto a
>>>> larger
>>>> +         * block size for the subsequent mappings.
>>>> +         */
>>>> +        out = 0 | ((MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1)) << 2);
>>>> +        break;
>>>> +    }
>>>> +
>>>> +    WARN_ON(phys & ~PAGE_MASK);
>>>> +
>>>> +    out |= phys & PAGE_MASK;
>>>> +
>>>> +    return out;
>>>> +}
>>>> +
>>>> +int realm_map_protected(struct kvm *kvm,
>>>> +            unsigned long ipa,
>>>> +            kvm_pfn_t pfn,
>>>> +            unsigned long map_size,
>>>> +            struct kvm_mmu_memory_cache *memcache)
>>>> +{
>>>> +    struct realm *realm = &kvm->arch.realm;
>>>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>>>> +    phys_addr_t base_phys = phys;
>>>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>>>> +    unsigned long base_ipa = ipa;
>>>> +    unsigned long ipa_top = ipa + map_size;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
>>>> +            !IS_ALIGNED(ipa, map_size)))
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (rmi_delegate_range(phys, map_size)) {
>>>> +        /*
>>>> +         * It's likely we raced with another VCPU on the same
>>>> +         * fault. Assume the other VCPU has handled the fault
>>>> +         * and return to the guest.
>>>> +         */
>>>> +        return 0;
>>>> +    }
>>>> +
>>>> +    while (ipa < ipa_top) {
>>>> +        unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>>>> +        unsigned long range_desc = addr_range_desc(phys, ipa_top -
>>>> ipa);
>>>> +        unsigned long out_top;
>>>> +
>>>> +        ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
>>>> +                       &out_top);
>>>> +
>>>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>>> +            /* Create missing RTTs and retry */
>>>> +            int level = RMI_RETURN_INDEX(ret);
>>>> +
>>>> +            WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
>>>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>>>> +                              KVM_PGTABLE_LAST_LEVEL,
>>>> +                              memcache);
>>
>> Could we give the RMM a chance to make use of the Block mappings by
>> creating the Missing RTTs to the level that may work for the current
>> range_desc ? i.e., if the range_desc is a 2M block size, we could create
>> tables upto L2 in the first go and if the RMM still needs RTT, we could
>> go further down to the KVM_PGTABLE_LAST_LEVEL. I understand this is
>> kind of an optimisation, so may be we could defer it. (Same applies for
>> the non_secure map below).
> 
> A simple change would be just to create one level at a time like this:
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index b79b96f7dffb..3f3ade1d3895 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -767,15 +767,15 @@ static int realm_map_protected(struct kvm *kvm,
>   			/* Create missing RTTs and retry */
>   			int level = RMI_RETURN_INDEX(ret);
>   
> -			WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
> +			if (WARN_ON(level >= KVM_PGTABLE_LAST_LEVEL))
> +				goto err_undelegate;
>   			ret = realm_create_rtt_levels(realm, ipa, level,
> -						      KVM_PGTABLE_LAST_LEVEL,
> +						      level + 1,
>   						      memcache);
>   			if (ret)
>   				goto err_undelegate;
>   
> -			ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags,
> -					       range_desc, &out_top);
> +			continue;
>   		}

That looks good to me.

Cheers
Suzuki


>   
>   		if (WARN_ON(ret))
> 
> Thanks,
> Steve
> 

