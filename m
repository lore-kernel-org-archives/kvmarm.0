Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2074.outbound.protection.outlook.com [40.107.247.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B64158D8D
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.74
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717172909; cv=fail; b=URqGQwr9X8MbZaaVAwEJoQ5laixcjw9jXS3eqE64d7ctXpGwuxxYXOccNtImS02LXEpIJqu6N4qjKJKt0ZTohq1AnXXUWzky1RMLuPw0mVdLpI2iupKF9Uh1Np7ki8B6g2dzJ1qnBRQKzMkzgSFgyCHV98tIbQxCewEGP/jw8wo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717172909; c=relaxed/simple;
	bh=M5YejkYP19wuqNIbsiQKllttvji9t77tAdoUr8agYpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Suhk1VI+MaXQXfMg+WF+IGdDr/VjwY+1iVOjfQ61QszN1Qy9yn+XRjHN4KMxRQzsx4J+BPpaLFgA5lSsc8s541cumvj4I7lqagiICfV6qTREv8xHg9xW0jGpqg+oAVTctgnnSAbfLUAH7EaCIdYfow+RO0zJwy+2ksBViAsMk9c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lfj0THfk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lfj0THfk; arc=fail smtp.client-ip=40.107.247.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lfj0THfk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lfj0THfk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=B0f6bDk73c+y0ua8Eg1xMAs2KUqdIeUET9s6OFp+QQqi9QNOqzgl7eJR7ahitdgBoXdDsxZY3llNMIGrArIfcRi1hWt7EeL+ari0cUIFn7GWCR2RjNoIk1hh4kGPQ17JaMTZfVfhxI92AZnSdct5DsMhHTkdO1E6SnlsavzHlv9xQSAVqeJ1xjWnbAgO+xnOTb1mFckntcOY9nDl7D+6oJqTX6+3WSHeP44H5hn5v6viDH1uLgnkfQYs6upM9NiOEU8Oj+0VN1goySbrtf2DUS2IzY/10PHxMvddbdzJKl7mUUrfFGm6sMm0Erhvrw0Z90DQBBn2QY8aBDVIdZkOjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/kn/zHXt6gVzEQJw5AhtJAJkce3Y+lTdMX6Rnr75uc=;
 b=iSEFB6LHIJdzky4CbQTph5WVVr6JVVqjggH1K308RBVsC+zen8LaFEz093jq7RsANwO5Z91lRf/kwJPxAG2vxsCgVXECdb7c3zgdXdfN+H0rK3ScdB6pt+sgqbDYntS7YhII3AhQbJmnmGjk1q0JOBrOIp1UzkvhQyQUV8aVl3TEZZPZFga6cHUZJbuDgls69N0uIE9l0L+jQQdLRgdPNzMPOMGp+Xy68xN7oBmhVq05d0Civ+n6l4WxzFFWxn75zWz5IuOpVig60RzLaVkpEsXNQhWyWbeuQIPDZb0WMcqjuhRrOIB9EEWpw1m55f4Ce8wIH8r8cW7BWFPOIkiq3g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/kn/zHXt6gVzEQJw5AhtJAJkce3Y+lTdMX6Rnr75uc=;
 b=Lfj0THfkcXU+tUgJiFdIC9gN6uf3BubapL8UJ+FFRmv/9z9qh5BtOTBl/gOYT8YlTxBEONOY+ixzoSV1IVlkt4TQsuf1S3cmFfGOVgC/NV8NrNTDDvxKkoRE/3zmXAEuD/P9hQcZU69pN6M/ZDOMyqPh27pPQKQxPAuiG35LRRg=
Received: from DU7P194CA0015.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::10)
 by AM9PR08MB6291.eurprd08.prod.outlook.com (2603:10a6:20b:284::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Fri, 31 May
 2024 16:28:00 +0000
Received: from DB5PEPF00014B8C.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::76) by DU7P194CA0015.outlook.office365.com
 (2603:10a6:10:553::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 16:27:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5PEPF00014B8C.mail.protection.outlook.com (10.167.8.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7633.15
 via Frontend Transport; Fri, 31 May 2024 16:27:59 +0000
Received: ("Tessian outbound c528c7fbb6d7:v327"); Fri, 31 May 2024 16:27:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 7366e6efe3ddcea1
X-CR-MTA-TID: 64aa7808
Received: from d362836c4795.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 02DD0AC8-7D2C-4EA7-B564-1BB6BED8F992.1;
	Fri, 31 May 2024 16:27:48 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d362836c4795.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 31 May 2024 16:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlqpQAQsVLplNdzfMZnrrU5zZ3W0wck2+RNWcxGh4P5hwsmvE+djdTBS+sjcEj70lIcN3PLXIF0kulznRekIhFAPpKmJxD/RypWSy7c4NVU4EDctmWdpGQK70e1ZxVB4YSpA2VDBkjvsIlshmwl2d5Ps0EUN1VAC4o/sBV2CvVG1zUUAFLagHA7iCjx8FKpjd9f+yUuVRsNB1CfXE6Mz7quj5dUr4bFVFcfo5RCKwlNulJRGPg4w7BtRGnbN5nTJBfFWeEMs3xfgCjbShNtYwEOwv2OnXPOdXh/34FSY5BCH41uJ9StBCVjqNjAr6U30RumnpWSnyUpp86kxM2POiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/kn/zHXt6gVzEQJw5AhtJAJkce3Y+lTdMX6Rnr75uc=;
 b=ifCMjfci/LdFa3lx8tQy+vd5yPOgkfUBSnh2JI5pINpouYnZlCn+IEW+fIF216M1vaRzd9BVhG0T8ymIbUFvbckycib0Jfyf3oRr8AHb9apJgcjH7n6+B9bQUWvSyNE9btsPqHB1zQH+iUEluDyQqrAIH9DFlxGCuMXG+agLa1RqhVc6e0J3S55r2ppsgECQnKKlxOzS/n4HZVC5WVYIHUzGQ8AIEVpHeHyMNe64ROgllF2gQJkWmBL4D8bShRY7GtuyVrRqjE2JSD9C4k728K9392CBrxFk/UqiGGrEytSnOwQj3Jt7b03mHRIu7MtkLKFBqXe7GVTCP+cJJMVfRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/kn/zHXt6gVzEQJw5AhtJAJkce3Y+lTdMX6Rnr75uc=;
 b=Lfj0THfkcXU+tUgJiFdIC9gN6uf3BubapL8UJ+FFRmv/9z9qh5BtOTBl/gOYT8YlTxBEONOY+ixzoSV1IVlkt4TQsuf1S3cmFfGOVgC/NV8NrNTDDvxKkoRE/3zmXAEuD/P9hQcZU69pN6M/ZDOMyqPh27pPQKQxPAuiG35LRRg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM0PR08MB5441.eurprd08.prod.outlook.com (2603:10a6:208:17d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Fri, 31 May
 2024 16:27:46 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809%5]) with mapi id 15.20.7587.035; Fri, 31 May 2024
 16:27:46 +0000
Date: Fri, 31 May 2024 17:27:30 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Joey Gouly <joey.gouly@arm.com>, dave.hansen@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, tglx@linutronix.de,
	will@kernel.org, x86@kernel.org, kvmarm@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v4 17/29] arm64: implement PKEYS support
Message-ID: <Zln6ckvyktar8r0n@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-18-joey.gouly@arm.com>
 <ZlnlQ/avUAuSum5R@arm.com>
 <20240531152138.GA1805682@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240531152138.GA1805682@e124191.cambridge.arm.com>
X-ClientProxiedBy: LO4P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::14) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AM0PR08MB5441:EE_|DB5PEPF00014B8C:EE_|AM9PR08MB6291:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae02864-a70d-4c99-888a-08dc818ea2ef
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?dmxJMnZEUElMU1lGRDQydmRJRzJITnBMOS9WWXV5UC9UYlBMTjRqT1ZCaGhy?=
 =?utf-8?B?TVBkODhzUVRjYUIrOXhNdlV1OURLTnFYNlUxeWpOUGR0L1UrSzNYNGJIbHBX?=
 =?utf-8?B?ZXBVN3ZLR1dFZElmK2FYaVVzVFo0cDF5b0wzTkJmWTBCODZoVE5RTW96Tkxr?=
 =?utf-8?B?T0wyYUY2Rzk0cUhiSXNEcEZsTWVrWjVyMWN6R0xsN3Z6VkIyMEt6aEdGQ0tm?=
 =?utf-8?B?WTdBQU5hSVdua3VpemRFeXM0TjNweEVxalYybTc4NUIvNzBkTjNZeGxydmhR?=
 =?utf-8?B?UXZqc3V1Uno4cDB5eTRsSld3cFhkM2w1ZnIyeWYwKzhvazhkNStCa0s3U0xI?=
 =?utf-8?B?QW91R0RVVm5MZkUreUhsYVBVWUlWZFc2R0hQdXhwZHBiQm02ZXJDQjd0eFlF?=
 =?utf-8?B?NmFBS2N5MmlHTnJ1OEJjaFBjc1AvbEJDNWloSDNtVlRmaEtRa3cvVTByMHFz?=
 =?utf-8?B?TUh2aUliZUl6NGI3TkJUc0pDdy9WT3dzVmJrR05GRHVreGNGdlhmZkhVdTlu?=
 =?utf-8?B?Mk03eCtUdTZNOGtNTXNRemhqWXFiUmFSZksvOFNmZmFaKzBISmNNc3pmYXFr?=
 =?utf-8?B?SzlUQmlLeW9rSmFWbmhLZEY4UEozSS8yVzhBY3VVSFpERDNMdzk3allpSXdi?=
 =?utf-8?B?VzRIWWdhMHQzdTVKaUFsbnhBblhsRVBmQTFTU1djN1I5K2dncFM5eGxBM3Rx?=
 =?utf-8?B?MVBMR3JuUzRPM2g3akw1OWVZc2ZUUENzVTMzNE1CMzhUT043VW0zVXlxMXNP?=
 =?utf-8?B?M0RTQzhYZUtqanhyc29xaEZOZzFiVUFmc2kxKytnY3U2L01NYUZLQ0FObTVJ?=
 =?utf-8?B?RXVLbHJjVkpVVlljSGs4Y3BpVkE3N01LQkRwMmhBcE9SeEVWNXdrdlBBcTVG?=
 =?utf-8?B?ajdxNWk5UnRIZmJKZWgxeFlCMFkzZWYwSDhnZVp5U1RmV1FvWE1GaVBWUTZB?=
 =?utf-8?B?eEdYamR0QjNOMlhvVWZCcWNwY2g0MlQwRWFTRGxobEt2MXlvell5bThtY01y?=
 =?utf-8?B?eVZza1hQTC80VldCeDVyNkRXaTkyWW1hWmF0NHZIM0NFZUt2ZEJVTlQ5aUti?=
 =?utf-8?B?bmY4YkVDZU83VUFPbnVXdDc5TDJsaEZEcmwyRWRLUGwxMEM2UWpEUWJqYTIw?=
 =?utf-8?B?ODY3L2pjbk4yMWxzSnZnK0xXZWg2Y2F6U1BYVElxTi9UeSt2SmdVVStTNHht?=
 =?utf-8?B?dkhjNWJpZWFHZk9CRHhNOW1tQ3RlM1h1VDYxa2lUZllnc0dsZUhLSDJ4Kzg1?=
 =?utf-8?B?NkZpb2NIWkxaS1FtVWNycWp1SlJFWGdIbjh4Nlp5N2NWRlRtYWNjdE9YQjdq?=
 =?utf-8?B?dTVwajQ5eVdZbDhBV09hby9rR0QzSFhqb0lSWXlhcVdPcVVqRDJqVkVoSmQz?=
 =?utf-8?B?QW92bHpXTExKTHQwYlUrMFJHb3ZuTkFOTVp3WlJZYjNrRXBvSk5XR1k2UlB5?=
 =?utf-8?B?TEdDclZmVk1BblBXbXYxVWRJbkZleTlFVE1LSHAycFZueS9YU1BTV1ZnQjlq?=
 =?utf-8?B?MDRCV2NxSU0wTGpEZ0l6RG9KNXBHb0NURWdCMXkzelFqNzZOV0xoUlpGdytJ?=
 =?utf-8?B?RnJvZHFJUVdldUNHdGZXREhncFpaWkZjb01DamdPUzhSblhqM2tDZUV3ck9i?=
 =?utf-8?B?Q21xd2h1WUZOcHRYQTNaaTY1dDZadEplaUpzYlNlcTdxdnZJNVZlR2MxYXhV?=
 =?utf-8?B?VWFjWHllYURRa2NuU2JVaDFNVHpLVzRqMFQ2c2VhVXUzNUFJRENQYzRRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5441
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd97360e-b982-47d8-3fb8-08dc818e9ae9
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|35042699013|36860700004|376005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFk5WGhKNWdGK0EyTGpRNTBadUVYQXNRR3JNY1YxUzR1bzdSMjBQTzQ0QU8z?=
 =?utf-8?B?ekk2MXVQV1J0dnF5dTJtamFlVmp0aG5sK04rMmtPcFRWeG44YUZaUm8rM0lX?=
 =?utf-8?B?dkY1d1ZvaGl3OVNJUTZvRXRLcDRnN01nSDBJQ3JnZlY1YjYxY2xKQTE4aTFh?=
 =?utf-8?B?UmxaaWJRNEMvMUUwelJ4UWk1d2FJbXRwdm1zTzZ4YnRQanNENFhTdkRJWGNa?=
 =?utf-8?B?ZzIvSk9WY3JRTFhWbHdaUjM3S3lhS1FVaDF4ZC9RTXNMa0g1dERsWmljNDVB?=
 =?utf-8?B?UGxlSXRBM2t2N0NTU1Nia01FMHIrWHJDTk90UURCeWZEZjhoeVBreC9RNTR4?=
 =?utf-8?B?K05kVDhwTmQwQlljeWc4aXhsbEF3VStoZlZjdG9uekt2UTlsL0FMQTVrenZq?=
 =?utf-8?B?ek5Vb1VYNDUyUktINDNpeTN5Mkp1OGxMcTZzL1dGTE1yWVdWUnM2OVdUc3pK?=
 =?utf-8?B?NXZRei84Y0ZHTlBpLzJuZmlZZ2FHZWdNLy9oMTdRMFlRSGxIYW5sV3A3NXJa?=
 =?utf-8?B?VzMwOUZpVlNNUVRzK2s0bWx4OURyUE1YUEpaSHNIN0VMOFJrSm1CVHFGTHNX?=
 =?utf-8?B?QkNtaDRwM1BoQXArYURLcVBIalFGUTluNHFZLyt6bU9lazRMd0Y1dHFsc2R0?=
 =?utf-8?B?K243YmVOeEMxTS9CQjQ0N0dQL09UU2JGTnVIZVI2bXRSVFowQWZreVBwZVhO?=
 =?utf-8?B?QjVsM3hhYmZ5L2o4MTFPSW9qV1N0dm5LYzN4eFArejF4S1JpODRpL0hLaHR0?=
 =?utf-8?B?RzVmSmxrRjNTVWtXNFR1MFBvMWRhcEZxS2VUVFAxMlJoanZrRG9IUU1YaVZT?=
 =?utf-8?B?WlpKcTZyYXlDWk9VODlEZC9XYWluRFZ1a2dLQmYxQ3IzcEdyVzdTSk10d1Bo?=
 =?utf-8?B?WXRzb3dxSHVxcDUveWNrTjZnRWVRN3U3ckRtY2k1TTc3RE9kaVZ6VHBzWmJs?=
 =?utf-8?B?ZEd4NWNVTzZpS1RkUm9nY3pQeGtQU2x1L2RaZGE3T2JzajVseC9TVWxvS0Fn?=
 =?utf-8?B?VHZ6RVplb3A1OGhiNUJBVVFBN0hnejFibXUycHBWa0VRek95d1VMOHR2eE12?=
 =?utf-8?B?bzIvdDVKSFN2NFQyaHJqc3oyVldpNkVMSnI1YVZ6SHEzUG5teWp6azRxVTln?=
 =?utf-8?B?NEp3RGtkM2NQdHVnTDJZaWFWYUlIemNOMDVxMlpON3ZNa29GZHRyd3AyQ1Rh?=
 =?utf-8?B?M3ZiT3lNNnFYS290YnhyeDhOZzd0emNISG5kZ1ZxYVphZWpNTE5nZ0xGRFRU?=
 =?utf-8?B?S1FCbFd2VUdCTVVoSC9mSHdoVTlkdWtpakVlV0ZmKzYzWjJHV2hsWWI0ekNi?=
 =?utf-8?B?TUJsbXhCR2hJN2dNN01BR29pbXdGcU5ENFh4NkVxc2tROWI4TmFIM1NDdGhz?=
 =?utf-8?B?M2xoRzErS2JCUXordEVMTSs4R1VpNUhXemJ4VGgxcml0UnFVZXdMVTBMMk5y?=
 =?utf-8?B?Wjd0TVovNnJ1ZFVMejV5S1NsVVpiQm5qa243YVRjMGtKUXhjNEYyamhKaVBV?=
 =?utf-8?B?QjlrVDVKMDNhaUlrMHJsYzF2aS95aEdCQTRndHRBQVYxNmpMVVZUUitBSGFv?=
 =?utf-8?B?OVBUaVRxYXpBdzhwOTRJNThuY3Fidldpam1rb3pna3VaMUZOUURoeXJuZUhD?=
 =?utf-8?B?bVRPRUlvbmxRV1krNWtxZnNTRjd6UndJK21POWFHNmxrMVc2MFFSa244cmdG?=
 =?utf-8?B?L2FGTHlQdXRBUzVLK0NueG03bnRjaWZYQU1EYnZlTFVzejdYTHE1bkJOR1RL?=
 =?utf-8?B?RzRVbTJGSG93emEzOVB0bmRrVkFIckNMREMyUGY4Um1Nd0ZqMW5RMnhicDRJ?=
 =?utf-8?B?d3h0OEVVS096K0t3TEZNTW43c3NiY1F5WEU4c2N3V2ZkWGZER1lHT2o4dVgr?=
 =?utf-8?Q?//4TFG4cpt0WO?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(35042699013)(36860700004)(376005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 16:27:59.8713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae02864-a70d-4c99-888a-08dc818ea2ef
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6291

The 05/31/2024 16:21, Joey Gouly wrote:
> Hi Szabolcs,
> 
> On Fri, May 31, 2024 at 03:57:07PM +0100, Szabolcs Nagy wrote:
> > The 05/03/2024 14:01, Joey Gouly wrote:
> > > Implement the PKEYS interface, using the Permission Overlay Extension.
> > ...
> > > +#ifdef CONFIG_ARCH_HAS_PKEYS
> > > +int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
> > > +{
> > > +	u64 new_por = POE_RXW;
> > > +	u64 old_por;
> > > +	u64 pkey_shift;
> > > +
> > > +	if (!arch_pkeys_enabled())
> > > +		return -ENOSPC;
> > > +
> > > +	/*
> > > +	 * This code should only be called with valid 'pkey'
> > > +	 * values originating from in-kernel users.  Complain
> > > +	 * if a bad value is observed.
> > > +	 */
> > > +	if (WARN_ON_ONCE(pkey >= arch_max_pkey()))
> > > +		return -EINVAL;
> > > +
> > > +	/* Set the bits we need in POR:  */
> > > +	if (init_val & PKEY_DISABLE_ACCESS)
> > > +		new_por = POE_X;
> > > +	else if (init_val & PKEY_DISABLE_WRITE)
> > > +		new_por = POE_RX;
> > > +
> > 
> > given that the architecture allows r,w,x permissions to be
> > set independently, should we have a 'PKEY_DISABLE_EXEC' or
> > similar api flag?
> > 
> > (on other targets it can be some invalid value that fails)
> 
> I didn't think about the best way to do that yet. PowerPC has a PKEY_DISABLE_EXECUTE.
> 
> We could either make that generic, and X86 has to error if it sees that bit, or
> we add a arch-specific PKEY_DISABLE_EXECUTE like PowerPC.

this does not seem to be in glibc yet. (or in linux man pages)

i guess you can copy whatever ppc does.

> 
> A user can still set it by interacting with the register directly, but I guess
> we want something for the glibc interface..
> 
> Dave, any thoughts here?

adding Florian too, since i found an old thread of his that tried
to add separate PKEY_DISABLE_READ and PKEY_DISABLE_EXECUTE, but
it did not seem to end up upstream. (this makes more sense to me
as libc api than the weird disable access semantics)
