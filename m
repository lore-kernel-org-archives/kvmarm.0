Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010043.outbound.protection.outlook.com [52.101.69.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B741D11E;
	Fri, 31 Jul 2026 10:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493287; cv=fail; b=fBcOOkd0esyJNhNlh59dGYOz9YjFTBV6p8QYc8tiCxsJ4tJNnS0PImeRh+ejpPc9BoxNM5wxoqoBllY7CT5TP4AOiZqjh9sPJHF3E6PCI++8O66OMCXmmDSAEHb+FodinuIXIxq+LnZTkHHjeIv6HOKrWVJBlhQZqFMTnmySpIU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493287; c=relaxed/simple;
	bh=uMoAa6ypQ4kWO2BjbH7g9hmwnsJB5qknnVS+XG6bi6s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hCnocl1jlw+vXLdfSeGiJrGVyE0BlVkTBshZ2s39lRozxjIKF0e7P95JFXKrxuUOFl073kD68QzxYwjl9zQ4JZLnNdiQoK5VG2JktxiPMBpBZ3X1CYeHvE1R8gUjX1IG6H6SomZJOgZ9nray9Q816ksMZLtEwrBw/RoC0ry1tJ0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mfw5t20j; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mfw5t20j; arc=fail smtp.client-ip=52.101.69.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mfw5t20j";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mfw5t20j"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kv6zG/BLOhzK8SR4UiqVcUTONKnv9bZNJwHzZsGxskN0ZK+AzQiEIxyo+bPzJEH74J9L3zR2Y61Tr+Oz/uR6Xk3Hw4uivW1PEru6oUQkzqDSbxrN2UrTgtAyfKl8F5Iakuf6vdwZ8XRg+UjbuZfKx6KB18qCbi6oaswxkiWeyZot/PAKLteQCdtMHMILgIOj8dC/GHwCt16YUDAL3zRYsvGH1D3CZGanQacrkChEFWPxhwtsKjNzxT980rhAErtTQoeL9HWo+0VumeQdDfd9CYSbwSAnQNufKl/6ImJzzxtb/uS6Qr5FdI+4vdf01oKATgoK2go+L2GFwcXM379Zxg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMoAa6ypQ4kWO2BjbH7g9hmwnsJB5qknnVS+XG6bi6s=;
 b=gIzQ3cf36KD/bRzjgTV4QPhdo1Q8UnCxHpaFtI5Y1fwRgo3sylL/xWnGBqYzpb2HjlGBY7hY62QFE8y7ajiKZZ7MS0kl5fJrzn8fLpL8vaH8zwx7FOZi0J41Fd0IFXdqqKGSD6liwjR/BUA5eEWLe0AC2ECPYq+CvuWgVdh0EGJuhtl8bCZWmE0M+hLTS76zfjQfVx5BXz7vtXMbc9WwmWFgLZOrfjGlDQy6/Vhy+sP99b0N+wYp9FJC5tTbkxfXiqol6/0GGv9EsrPQqhXe5C8LbcEqx/qmVQ8Dym5dSptLvJJYKaozzYRPPtB6KHSWha/XE1QidMg0d0mn2O6+gA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMoAa6ypQ4kWO2BjbH7g9hmwnsJB5qknnVS+XG6bi6s=;
 b=Mfw5t20j3ZbCBEoZ+y/1gNWSj2h5rzrUqWqjrfVRnR8TA/3UsFQM8haTN2tiN05unKNL9rZaSvaEbv4s8DNoeFbJxlv6Ubx/nii8VDSkcmzaTqeQ73gVmgFFIB59v3hbwn9f2QXgvzb3wYyALJVL2KcdbduV99n8OWa8HyD8Wuw=
Received: from AS4PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::12)
 by GV2PR08MB8749.eurprd08.prod.outlook.com (2603:10a6:150:b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:21:05 +0000
Received: from AMS0EPF0000019A.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::a7) by AS4PR09CA0009.outlook.office365.com
 (2603:10a6:20b:5e0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 10:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019A.mail.protection.outlook.com (10.167.16.246) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 10:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ddoy3OUYwpKf/NHzNwPn5NlGdsA16W1Vqo/ihAD3TcZiH3aBORoBgT2+GOaLTHn7Aqea3SIBLrud9YszYiWSxUPBtXP/wrc6CK9iW2DTkazaajSMhajqcHHFaPHIjWMfo57W2FbYdBS0Hxcr9Ey/Fom2eb6WIdsPIWd7rAA06RWesOoD5LFT0E+QXCvrU2wtrt72iPkPp15INznF9jSY9lZspapexFlvpkmPgvvLjv3gXVV6s6nYFJ2Hx5EIpXmwraVDq+cWptZmgPPd2fTC9FWl6m8hiXzrGPxSqdQetgEE5gb28n3MuDR90PhxtG3bggUxRO+n4DaDwwxwfiO+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMoAa6ypQ4kWO2BjbH7g9hmwnsJB5qknnVS+XG6bi6s=;
 b=RO56IUKxbzoHQG7QqurR0f0HUw7gzjhB+J5+x18js1ONTfMUql1KYsaXvwftD+CBUg96ywBPm61GBW+iJykPz2DSMUR8gAMtuHOlsMHRYCxf2y6bOXF6Ursct7YQRJLK5H1coojweqscnOjqbbQu0WYJtwzEyDpqdb3KnyTZQHowlIkmSYsNUHLvovHArxVEyfjC9zh+6txwtH9vCXU2OYN/w+bc2rKClxeKI5jb446P/gTdbkXh7E2HbanxaBHxucNokniEFT8AmK6W+zVXB3BeuBeGrPskYVViwFFxMmVPwxt8UtV7y/ewaYKllWx7469iWh49RPyf7nkn2s+5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMoAa6ypQ4kWO2BjbH7g9hmwnsJB5qknnVS+XG6bi6s=;
 b=Mfw5t20j3ZbCBEoZ+y/1gNWSj2h5rzrUqWqjrfVRnR8TA/3UsFQM8haTN2tiN05unKNL9rZaSvaEbv4s8DNoeFbJxlv6Ubx/nii8VDSkcmzaTqeQ73gVmgFFIB59v3hbwn9f2QXgvzb3wYyALJVL2KcdbduV99n8OWa8HyD8Wuw=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS2PR08MB8312.eurprd08.prod.outlook.com (2603:10a6:20b:557::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:20:00 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 10:20:00 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdG1qHixGm7P28DEaB9oxXfibtS7Z8i/GAgArpoYA=
Date: Fri, 31 Jul 2026 10:20:00 +0000
Message-ID: <faebdbb14014c073941e76beee7ae42376b9e077.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-17-sascha.bischoff@arm.com>
	 <20260724114111.E44D51F000E9@smtp.kernel.org>
In-Reply-To: <20260724114111.E44D51F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS2PR08MB8312:EE_|AMS0EPF0000019A:EE_|GV2PR08MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d0cda2-e949-4054-68d7-08deeeed6dc0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 IQoEWCfbezAqGz0sSDBOKN3M6sBaiNyTq1+kQqQ6Y5XRmYga02ezf3Dh5NMO1wKm6nhu7lpPgXt2um9FaDYE/mZl/ytYQIRxoYI+JhhnXnxF+0bhlKeZzz2Q1oRULx3GKMds5Mj41ZzvdIUR2WcwplBcGnyx7cWc3AZiTdRE63xz1yIVMLXxZi0T69ERMT2bhcVsX1eI5n1McjuYbv5gHlgrQV4BF2t5Td1D/lsdMJ2V0Ec7UvpSWH5UKStwITo+74uOkLXfcQyYfaAm2WlEW1vY7/2mbfYAg1H5AySgnTCNhQGtdgBiXMNS6nhjSYGuS81VPUosOqsmYxp2geQkQFwdemrEoku3ieYhpa7y54gkvQY+7UO1naJA+waQOwlip2BqGK9U7E6tolz8jsA205BkvbbMyjg6fshx707wyBmQNKL/5qT06aw4YMw2wcc/ukPpShLrMhl1FZnXUGKd0A2wzXMlD/kz2v4CkI2QRTOzZdqK5ndM4uVuzOcYSBiZNlcoUMZbH4qWasM6ncxTKvWNqOxX9BDJNPh3wnbj9wkx6WTa02FEwq1Guxug7Fis0eqWtZmTg0q04fadb7rGXHGcIrkKQPi6mKq3KIA1/y1B7aVR+d+oGrrDGhguNcTElKAAjptEzk3lh4LWpRGIO/kSQCrJdqESJSIdrUDtEYyzVnBsJF0pP3ELZa+tTuccGwdOZIGFZO3lW1+YNTHN36j1uRemy99hwj0cbIDV7JA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <91EAD27B26CF4F4AA202DBEE5D51A8EB@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Hw3dlegZs1jOtiRED3fWe5MhNIltr7HKHFH8aYPUM4odyuUpO1JLWY7Qr7lCCKC4BYcbdRw+ruKRZeNijtXs2IsrBCjUv7RmsC0DuDBQuUmdioqyM4tV5c0ADHkuKWx9m+lSStdXb3wHJQaQ2JTPtSv2P57lZkFeVmURN26NvVex9V+OFJmkn8Jo0OJCJPDtjmxT7uI1tSg1FOAvO2ahobye05rAAwVvkYa6fzPihbmvB3r3+gnhvh1OvZKsXFv8dfV1kvUFr5dq5ur5e7YYExZw7G8ZTQR6m0zxpid1oqIum756/QgNISUnCNZL4Z9Hx9QbKriS3nRJTtPqGl8aUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0ea2d611-cae4-4e56-24a6-08deeeed4759
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|23010399003|376014|14060799003|1800799024|30052699003|82310400026|6133799003|10067099003|4143699003|18002099003|56012099006|11063799006|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gckTtBL8LR2p6SepP5bxEVhHI4C0lBt1Yk4B4UmZIGaE+cx1fxU08mTRxvzw8FXVujmn8DLCzpw6WoC8+XtYuB9VF+FCrDXV+YC5Ara8g3W/8l1e0RyP5WLMhJpRRpmMNxXU6dh85K06qF8VkUapiIVAsKi+odx8m9BLUWDPbyFbu1Is7N7Lrz4yOhY9DFXPh9+/Fo+GSMMF1GORdr/axlPqFcxoAFPBUAvTn0xyqgExy18QFlxH+Qf3pTzNuLXWSwC1d0Q544lSZTeyv+ORP4WdtiH2fWcQKqr7z9dTRqyGvpsFkojrIxp8HQLW1DIN20YwFABK+JaQkAQotf8IWI4JlNGJW1ZGJq2QMqPPOGxMXqIVszmfzX5ezO0Ft5t+5Ipnbwm37skhli5ypqT0InXk2hCTG6Zv2SWc9Z9fYipZPMSjKa2aN7UmJVKCkmsyMjCRUywDWKOwQhAp4CIgOjqK2k1eriwamB7UzcaLu3mC8HwGy2OklxP1shMxm5KSYeKxVk5gs2xbzOSrirC6I3bP8Dk7f7jv8o6tjA8Pd39/AcO3jvlaDq6H+7K3a2zMlW06Y5hpMGBCr7Mf3Imwjb5XnnMgVNW4hKUVdIYs2vMRjq5pk9CgHRO+tkFBfF7FOaxMSvRehAtdKE3soJI2MxWA+E7RZ+ZD2evsBypmFUAN/CkpHRJmJSPqG5LyWtslvpBVGU95SlwS9CKgnPH0mQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(23010399003)(376014)(14060799003)(1800799024)(30052699003)(82310400026)(6133799003)(10067099003)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wvUxH4AuyJSYeYeA1V6KtZYNOETPIBwfB1s4mvCBGjTx2KCPjyZRH8iMAlodrx9ry8pRtUb2Lm1AMItuiVSobaGF3P6ywD2pf5ReqDJqxeEA1+wL5tkLmK6nRjkYeUAFqD7ZEQhvWcKXN1/6Ammo2tWq7g3vm/igfONNhIol2sjZr2Frlascrbz1HL3hvAnLFTDm67ye80qtFtXNzYdU/KO28o4o7iVVgV6x9wdQ3toyND0vDy2Aafz35niqEuYrgIbpGgzWd3enP82jzOzeioWSE3MptISTc313R+JcK8SBE3+ytmNO+10ozgtIM44U/0vZlKyLB2YrBuq14Epqt3Gag+1IWBFjcHzUZjtk1OFffLcyt4LDBNcdyh1u96gy+nM5uw12rUHbacHtHGYw7E3eiqNGq7BrJo7frxlHdt/Z14mvfaVmSiHpRfKvfDEj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 10:21:04.8183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d0cda2-e949-4054-68d7-08deeeed6dc0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8749

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjQxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gU3RhbGUgYGRiX2ZpcmVkYCBzdGF0ZSBjYXVzZXMgYW4gaW5maW5pdGUgbG9vcCBieXBhc3Np
bmcgV0ZJDQo+IHNsZWVwLCBwZWdnaW5nIHRoZSBob3N0IENQVSB0byAxMDAlLg0KPiAtIFtIaWdo
XSBJbmNvcnJlY3QgR0lDdjUgZG9vcmJlbGwgcHJpb3JpdHkgbWFzayAoREJQTSkgY2FsY3VsYXRp
b24NCj4gZHJvcHMgcHJlZW1wdGluZyBpbnRlcnJ1cHRzIGFuZCB2Tk1Jcy4NCj4gLS0NCj4gDQo+
IC0tLSBQYXRjaCBbMTZdOiBbUEFUQ0ggdjQgMTYvNDhdIEtWTTogYXJtNjQ6IGdpYy12NTogUmVx
dWVzdA0KPiBkb29yYmVsbHMgd2hlbiBWUEVzIGVudGVyIFdGSSAtLS0NCj4gY29tbWl0IDRjNjll
MWU3MWY5MTVjZmM2YmE3ODU1OWZlNDQ5OTgzZGVlMjBkZDYNCj4gQXV0aG9yOiBTYXNjaGEgQmlz
Y2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1
OiBSZXF1ZXN0IGRvb3JiZWxscyB3aGVuIFZQRXMgZW50ZXIgV0ZJDQo+IA0KPiBUaGlzIGNvbW1p
dCByZXF1ZXN0cyBhIEdJQ3Y1IFZQRSBkb29yYmVsbCB3aGVuIGEgdmNwdSBlbnRlcnMgV0ZJLA0K
PiBhbGxvd2luZyANCj4gS1ZNIHRvIGJlIG5vdGlmaWVkIHdoZW4gYW4gU1BJIG9yIExQSSBiZWNv
bWVzIHBlbmRpbmcuIEl0IGFsc28NCj4gY2FsY3VsYXRlcyANCj4gYSBkb29yYmVsbCBwcmlvcml0
eSBtYXNrIChEQlBNKSBmcm9tIHRoZSB2aXJ0dWFsIHByaW9yaXR5IHN0YXRlIHRvDQo+IGF2b2lk
IA0KPiB3YWtpbmcgdGhlIGd1ZXN0IGZvciBtYXNrZWQgaW50ZXJydXB0cy4NCj4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12
NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gWyAuLi4gXQ0K
PiA+ICsJCS8qDQo+ID4gKwkJICogUmVxdWVzdCBhIGRvb3JiZWxsICp1bmxlc3MqIHRoZSBwcmlv
cml0eSBpcyAwLA0KPiA+IGluZGljYXRpbmcNCj4gPiArCQkgKiB0aGF0IG5vIGludGVycnVwdCBj
YW4gd2FrZSB0aGUgQ1BVIHVwLg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmIChwcmlvcml0eV9tYXNr
KSB7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgc2tpcHBpbmcgdGhlIGRvb3JiZWxs
IHJlcXVlc3Qgd2hlbiB0aGUgcHJpb3JpdHkgaXMgMCBicmVhayB2Tk1JDQo+IHdha2V1cHM/DQo+
IA0KPiBBcmNoaXRlY3R1cmFsIHNlbWFudGljcyBkaWN0YXRlIHRoYXQgdk5NSXMgaGF2ZSBzdXBl
cnByaW9yaXR5IGFuZA0KPiBtdXN0IHdha2UNCj4gYSB2Q1BVIGV2ZW4gd2hlbiB0aGUgcnVubmlu
ZyBwcmlvcml0eSBpcyAwLg0KDQpLVk0gZG9lcyBub3QgZXhwb3NlIEZFQVRfTk1JIHRvIGEgZ3Vl
c3QsIHNvIHRoaXMgaXMgbm90IGFuIGlzc3VlLg0KDQo+IA0KPiA+ICsJCQlpbnQgZGJfaXJxID0g
dmdpY192NV92cGVfZGIodmNwdSk7DQo+ID4gKwkJCXN0cnVjdCBpcnFfZGF0YSAqZCA9DQo+ID4g
aXJxX2dldF9pcnFfZGF0YShkYl9pcnEpOw0KPiA+ICsJCQljb25zdCBzdHJ1Y3QgY3B1bWFzayAq
YWZmID0NCj4gPiBpcnFfZGF0YV9nZXRfZWZmZWN0aXZlX2FmZmluaXR5X21hc2soZCk7DQo+ID4g
KwkJCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7DQo+ID4gKw0KPiA+ICsJCQlkYnBtID0g
cHJpb3JpdHlfbWFzayAtIDE7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgc3VidHJh
Y3RpbmcgMSBmcm9tIHRoZSBwcmlvcml0eSBtYXNrIGRyb3AgdmFsaWQgcHJlZW1wdGluZw0KPiBp
bnRlcnJ1cHRzPw0KDQpOby4gV2UgZGlzY3Vzc2VkIHRoaXMgbGFzdCB0aW1lLiBUaGlzIGlzIGNv
cnJlY3QgZm9yIEdJQ3Y1LCBidXQNCndvdWxkbid0IGJlIGZvciBHSUN2My4NCg0KPiANCj4gVGhl
IGhhcmR3YXJlIGRvb3JiZWxsIGNvbmRpdGlvbiB0cmlnZ2VycyB3aGVuIHRoZSBwZW5kaW5nIHBy
aW9yaXR5IGlzDQo+IGxlc3MNCj4gdGhhbiB0aGUgdGhyZXNob2xkLiBJZiB0aGUgaGlnaGVzdCBh
Y3RpdmUgcHJpb3JpdHkgaXMgNSwgdGhlIHZDUFUNCj4gc2hvdWxkDQo+IGJlIHdva2VuIGJ5IGFu
eSBpbnRlcnJ1cHQgd2l0aCBhIHByaW9yaXR5IGxlc3MgdGhhbiA1LCBmb3IgZXhhbXBsZSwNCj4g
NC4NCj4gDQo+IElmIHRoZSBwcmlvcml0eSBtYXNrIGlzIDUsIHRoaXMgY29kZSBzZXRzIHRoZSBE
QlBNIHRvIDQuIFRoZSBoYXJkd2FyZQ0KPiBjb25kaXRpb24gdGhlbiBiZWNvbWVzIHByaW9yaXR5
IDwgNC4gQW4gaW50ZXJydXB0IHdpdGggcHJpb3JpdHkgNA0KPiB3aWxsDQo+IG5vdCBzaWduYWwg
dGhlIGRvb3JiZWxsLCBkZXNwaXRlIGhhdmluZyBhIGhpZ2hlciBwcmlvcml0eSB0aGFuIHRoZQ0K
PiBhY3RpdmUNCj4gaW50ZXJydXB0LCBjYXVzaW5nIG1pc3NlZCB3YWtldXBzIGFuZCBndWVzdCBo
YW5ncy4NCj4gDQo+ID4gKwkJCWNwdV9pZi0+dmdpY19jb250ZXh0ciA9DQo+ID4gRklFTERfUFJF
UChJQ0hfQ09OVEVYVFJfRUwyX0RCLCAxKSB8DQo+ID4gKwkJCQkJCUZJRUxEX1BSRVAoSUNIX0NP
Tg0KPiA+IFRFWFRSX0VMMl9EQlBNLCBkYnBtKTsNCj4gWyAuLi4gXQ0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLmMNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+IFsgLi4uIF0NCj4gPiBAQCAtMTIyNyw4ICsxMjI3
LDEyIEBAIGludCBrdm1fdmdpY192Y3B1X3BlbmRpbmdfaXJxKHN0cnVjdA0KPiA+IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+IMKgCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gwqAJc3RydWN0IHZnaWNf
dm1jciB2bWNyOw0KPiA+IMKgDQo+ID4gLQlpZiAodmdpY19pc192NSh2Y3B1LT5rdm0pKQ0KPiA+
ICsJaWYgKHZnaWNfaXNfdjUodmNwdS0+a3ZtKSkgew0KPiA+ICsJCWlmIChSRUFEX09OQ0UodmNw
dS0NCj4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1LmdpY3Y1X3ZwZS5kYl9maXJlZCkpDQo+ID4g
KwkJCXJldHVybiB0cnVlOw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBDYW4gYSBzdGFsZSBk
Yl9maXJlZCBzdGF0ZSBjYXVzZSBhbiBpbmZpbml0ZSBsb29wIGJ5cGFzc2luZyBXRkkNCj4gc2xl
ZXA/DQo+IA0KPiBUaGUgZGJfZmlyZWQgZmxhZyBpcyBjbGVhcmVkIG9ubHkgaW4gX192Z2ljX3Y1
X21ha2Vfbm9uX3Jlc2lkZW50KCksDQo+IHdoaWNoDQo+IGV4ZWN1dGVzIGR1cmluZyBzY2hlZHVs
ZS1vdXQuDQo+IA0KPiBJZiBhIGRvb3JiZWxsIGZpcmVzLCBkYl9maXJlZCBiZWNvbWVzIHRydWUg
YW5kIHRoZSB2Q1BVIHdha2VzIHVwIHRvDQo+IGVudGVyDQo+IHRoZSBndWVzdC4gV2hlbiB0aGUg
dkNQVSBzdWJzZXF1ZW50bHkgcmUtZW50ZXJzIFdGSSB3aXRob3V0IGENCj4gc2NoZWR1bGUtb3V0
LA0KPiBrdm1fdmNwdV9ibG9jaygpIGV2YWx1YXRlcyBrdm1fdmdpY192Y3B1X3BlbmRpbmdfaXJx
KCkuIEJlY2F1c2UNCj4gZGJfZmlyZWQNCj4gcmVtYWlucyB0cnVlLCB0aGlzIGluc3RhbnRseSBy
ZXR1cm5zIHdpdGhvdXQgc2xlZXBpbmcuDQo+IA0KPiBUaGlzIGxlYXZlcyB0aGUgdkNQVSBpbiBh
biBpbmZpbml0ZSBsb29wIHJldHVybmluZyBmcm9tIFdGSSBhbmQNCj4gcGVnZ2luZw0KPiB0aGUg
aG9zdCBDUFUgYXQgMTAwJSB1bnRpbCBhIGhvc3QgdGltZXIgdGljayBmb3JjZXMgcHJlZW1wdGlv
bi4NCg0KRW50ZXJpbmcgV0ZJICh3aGVuIGl0IGlzIHRyYXBwZWQgdG8gS1ZNKSByZXN1bHRzIGlu
IGEgdmdpY192NV9wdXQoKQ0Kd2hpY2ggbWFrZXMgdGhlIFZQRSBub24tcmVzaWRlbnQuIEF0IHRo
aXMgcG9pbnQsIGl0IHdvdWxkIGJlIGNsZWFyZWQuDQoNCkluIHRoZSBldmVudCB0aGF0IHdlIHNs
ZWVwIGluIHRoZSBndWVzdCwgdGhlbiB3ZSBpbmRlZWQgd29uJ3QgY2FsbA0KdmdpY192NV9wdXQo
KSB1bnRpbCB3ZSBzY2hlZHVsZSBvdXQgLSBidXQgdGhhdCBpcyBieSBkZXNpZ24uIFdlJ3ZlDQph
bHJlYWR5IGNob3NlbiB0byBzbGVlcCBpbiB0aGUgZ3Vlc3QgY29udGV4dCBhdCB0aGlzIHBvaW50
LCBidXQgd2lsbA0KcmV0dXJuIHRvIHRoZSBob3N0IG9uIGEgc2NoZWR1bGVyIHRpY2ssIGF0IHdo
aWNoIHBvaW50IHdlIHRha2Ugd2hhdGV2ZXINCmFjdGlvbiBpcyBhcHByb3ByaWF0ZSwgc3VjaCBh
cyBtYWtpbmcgdGhlIFZQRSBub24tcmVzaWRlbnQuDQoNCj4gDQo+ID4gKw0KPiA+IMKgCQlyZXR1
cm4gdmdpY192NV9oYXNfcGVuZGluZ19wcGkodmNwdSk7DQo+ID4gKwl9DQo+ID4gwqANCj4gPiDC
oAlpZiAoIXZjcHUtPmt2bS0+YXJjaC52Z2ljLmVuYWJsZWQpDQo+ID4gwqAJCXJldHVybiBmYWxz
ZTsNCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
