Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792505390;
	b=BlzV/dRygLIkzMZznXX/OU7LkKBHIFj1OZwTZEDKDBXiq0FJ5c6JWOlaoJ8ADGEA+waB
	 uwO8wIGEPqgBERL8jamROvXpA/FkeqKkjRfKegO+UXlf4KwGLxXhNRo7dXT1qcLUaDgNA
	 lLVzFrUcHMqwEjFPaEfDKwcCq9xY/1H4Bev23S0QDEgYnZyjjIQCWSh9CuK1HT4CWi/sW
	 sBtn3Cl9sW2zMrn5YjvUY4XecDWJEuJHHOOQAlDsB9RqOAhHzCKflSsYBr3P5w1eAKh/0
	 hS26gThlXsCD4uEdf79frGf+zcsW8+kpU6j0p7xhCoBWzsVHpAd10DrllAiEIk+gZlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505390;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=IAF6xD5cIQqwIJ5T8c6143w+PZ8zjeS48r8fgDdrypQ=;
	b=VcwSwwQ+92vVTsby8nEnePGLiTXYJ61MYxI2nOi/Cks5hrKuuDTOHMIw8iCUacfApqc9
	 wP7lR7wIJvc3UG2AqZRv9q7z3W7YJ3ClLrpR9f/hTFkO0foMUgFTKNPjx+zk54Apxy3Oa
	 3boIgicltRWE/gJJK6bZx5KDZvur0HYyRf1vucI1imzSblUjwBSnoFyEvYsW2MRLPgK5m
	 Ybs3cb+/S77EcNOjpN/0k/ARvNq46OAJXznMpyUI5jHWoHSlsv9zHuAUtxKOjvPcB76mr
	 XAOqa0ruy+nGHhX9XOCSnAGd8FFHcqTJ428G3KyvEDQzaNQAF77C8Oc72mZ4hnpVQTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W+1Tpzxb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.45
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1C5606A319
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C1C5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W+1Tpzxb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEFRx3FpCxoKBdz0GxWNR147hNCE5M/5SLCTz7DEgTRMVQpVBIHZK6lseTTuph0wuW4UGfu9qqQCL1KhXAbWgMTSwCZtWujB3Qwf8U9Ay9+x+/UNxzf1B2xGTPeBmJ/WTzvAzQFmItOWDRKzRdop6nYjjjF9cBs9fRMlZG05fxZEzDobiisB424mtUxeglgNP7zpa/a19IHuM/dscDgArGrZ3iMS3fcPRDD6PYFkv4c8HsKrWM/JiYCXKHZ/TFsL0MmYfeUZYYCFbke/FWZBj7V2WU8i3FAygaruNQTBVrR8HiFvrfPJjmHmfg8W6qgaAnYmCULJTbC2YvVteEQMng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAF6xD5cIQqwIJ5T8c6143w+PZ8zjeS48r8fgDdrypQ=;
 b=lwjoZ/hOH6b6ccSvkEh9HsbttwrzFJQMNR4glj9szOAfOy/tfAuKj4CmYh+3nf38fjnW5EHoiOuFnCSZR3M0xQ57502izd8UMWqPqCbKRBtE6Snh0YKznqzaV4a025hKzG+qRw2THgp3aAAnE5NXUcacIyttOo88IuEmhbB80R9eKYeWQhWo5grLg2VV929zceu/fBJ/zJN+Is0QoafUyT3/QuJQDOLOrq42mBT3+7pDUgsY92y/nk6A5/BoGz5ySD7wGCMuL/MbGRoq7Dp4asWx6jpNd9IHG7Il4pOqPYGBbxrFodXDH6rwfGsWQKQ6VV1oi0W/n7dGaENi+YJcKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAF6xD5cIQqwIJ5T8c6143w+PZ8zjeS48r8fgDdrypQ=;
 b=W+1TpzxbsEfaA2Ml+KUj31px5w3L3wjRZYyB1Ixl9B/8VsF9dCduQU8hC1zEe2tzgMaMgLnnKttj9d45MUDyKUP6fx51va/oNamLdYijvNbZsECtJjtt8xjcqJhja/CQiRzkKHvXCgno3cuJFgyqGE5ld6ET967VKM1SwQlHTTDk786SZY/vgW07tNMuwDH8YM2gzqiya5vPHhm8+QmXM31TkNcCuvPe+OqUHuF2rqae3BYYVNm6JxEqXM8pLWqGEwqIjdgr9Gl0JnwwHq9MxjzSZnYZeqrpkCrbj2xK99B3bC+rqkhQiaDhaFckZOg1IViwM0YndrqsGDAko0C90A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB7978.namprd12.prod.outlook.com
 (2603:10b6:806:34b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 14:09:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 14:09:45 +0000
Date: Tue, 20 Oct 2026 11:09:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the
 CPU MMU
Message-ID: <20261020140944.GA3008132@nvidia.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-13-ryan.roberts@arm.com>
 <20261015164421.GD13920@nvidia.com>
 <95e0f9bd-0203-4c7a-9d09-622593bb3d4c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e0f9bd-0203-4c7a-9d09-622593bb3d4c@arm.com>
X-ClientProxiedBy: YT4PR01CA0295.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::6) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB7978:EE_
X-MS-Office365-Filtering-Correlation-Id: 00731ed5-fd8b-4d9d-cf5d-08df2eb3cb07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Cz7BeM2k8TLaYCRI1wcVMG1vH3fs2+zCxx5jEUAxTsGXu7jXURwDzkbUO32iPvXgH/gNPhMVcU1rVID+1EV97Lv1jhKnVJ4RNPw/G0q7OOcu+O978/os12QkZbnUzbDX+I4d9y7TOGuJFKF5UO5JuxRUVqwaKw6FiG4kxxIsldoBbLG87vKhMRMW0Em29JK9OafDPpyj7yXvj4EY9IlUCsTPO/BiFUA7OrrdTiUBcLYbwO0F806pa1sjC15ACFm2vez6md0mWWLsN4yLonJUGDc8Z6sCZONTLOabIYY/GJoATIJ8sptlYJowG4i8+U7U2DQZuPJGc61UHmtwEHIzu+O60NUU9rF2PAzHiETKb42tsRbgcboiOBMV7O6uFBTO59Y0PeWbN2ce9Fu/K7j4tnLPWFYsyG3uQpLF/sozb+v5tXJu5ykhfZgxmGz8a4uGh0qkTekOjWJ68ZlMFM1EAfdBMI6ORqH4xIG9ug7fbUeF12FAolABleQONvvGIxw7Jx4eWjHxaY8yBfv/0XYFiGSi20sooN0yUYEkhm+NJP9C9TVUmKG95j1g+oHA/RzrxFOOBTcQTeReNGInm62kGsvrVd1ZS84g5Jj74UsgEV6JFq7HAoEzp3yk8MXFJ60E44vn6hso74Z4HKTGOyWXZfQp9vpWYlkHVR567+0qTFM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RbyNzpgHf4nBHZ0rmqq+8dp14yfsOCAN5A7BbBVb5oQlZ7TXCyBFWTdOPcTi?=
 =?us-ascii?Q?CrYGMD9L5tqjTjkrHytRKYwJ7MEUs6qJR0S/Zt+klnlVn9WBYvOGbQHYA9zq?=
 =?us-ascii?Q?L78MUywrzWMdFcwOerjNMU2h3RjWFp/1ht9FYILCLCVx4J8Qi6BLoc3J6uzj?=
 =?us-ascii?Q?4iro8pTblpcxnouP3i8Mp76GV4vTzP0xWjmlv9MPHPgPv45wV8/jsdvJ1BqB?=
 =?us-ascii?Q?asCk2zcD38m1iYq+dZYsjJ1CzxGkoPNB3MVdsZmwXJDt1NdE4o+2JRkUdDHR?=
 =?us-ascii?Q?LPApyRdwCiO2dqS2lgRrmybPgCJjb3XsXMU1k2uLoMezGomniqPFRNRYhiRN?=
 =?us-ascii?Q?olnyZeHNcszv6F9sOt/tOowVjwHXdwoU3MCIERucwoqRn8FPjrAalY7aIxG7?=
 =?us-ascii?Q?dsKdZmv+zjsDm8t/3e501gvN6RUR5rKgZCM4MByhOaKbuLIsmRCPzHWkG4Mj?=
 =?us-ascii?Q?kyRoT4QVNDoF9EDdXJy3uPU8RvIjq1tM+17eUxjrccQWgJlrx2dsnL7LBUrM?=
 =?us-ascii?Q?QYccQO2m+9weSyTzd1xbbQ7KE92HV2It5Y3yDK0rIRUUD+xNIgRNBXXb5plp?=
 =?us-ascii?Q?FF/gp1gF41g0EtBeMm57BM00EWOkrxM6WWTggbFaZtwNMkBELeJLEqOE+eWB?=
 =?us-ascii?Q?/I0sqVj9Ufkn3YY6f6RA8zqKXg6WzoWs8PeVPzeRcW3I0BUxMCqun9CH2HBi?=
 =?us-ascii?Q?ce5i5eZb6l82RdXp/3N8/OvlmK11CCZM+HpUyybqV3Tu6OLd8OIlZ9FWROCB?=
 =?us-ascii?Q?6m6pMQwKsYe7O78DkDGfX1DKaF2EdiY5/tmLvrG/8cAkLE2SPd/AAgyXI2OU?=
 =?us-ascii?Q?Z+jd2lXpwPYZekQlhDCjjfFTP5R8qnxiL7yW8RK7DYz4KS2bo0gcvLWiVbeQ?=
 =?us-ascii?Q?b0YkRMS98C50RMzi2bk6qcFqBvKpOqQQg0yBv7Rjwe8A7K6QeW/k+2BC7Dpb?=
 =?us-ascii?Q?hqU+x0xsAwtSwQA27pFhchGpVa1qDKEFaIpnOzcnu4nvUSUcdQoVHAT1BVOl?=
 =?us-ascii?Q?4R1CM32x+fJYLe4vMvbBmLOnGEEDA9P46ByUs00EMLGwkZQEMqKooj/ErcQu?=
 =?us-ascii?Q?Kn1vl8rvugFy2G3N39LoAHh7lQSi/DUqxemP7fT/bp8FwheR0efQAzyiSkmh?=
 =?us-ascii?Q?Q09EZjyIO7nclvrc+w5wUkSXI766nFaJUW9vXPaR/tJPsBLS2KFOp86AFzNt?=
 =?us-ascii?Q?TiEqCMaFpIidHLPofWcde6LeOTBJ/TK8TSpWo58KjNoAizzhfAd2dXuG1X/Z?=
 =?us-ascii?Q?WK/zYwz9Go9IAK1+4ZTuD9C8PUEWjZShkUJnEczVdroqlWzjq138g3sIT8tm?=
 =?us-ascii?Q?WEFzQ3YGZI4nL7CCEnu1G6sdVnwnITWXi6b18zyQPFsiagilw3YiE1IoH0jN?=
 =?us-ascii?Q?oTlKwXmlRdIOpJbdOekjc5Bm/wU7ZvgMNN1Ln+8n/8Y36NToP+2h7fLujjHj?=
 =?us-ascii?Q?qGKNYJkVpZcrykrYCVwZTlaM737Ach8nmAQ8Z84QyW2UNcnFQy6OXQMFZR3Q?=
 =?us-ascii?Q?TvSgu8hjUCUwE59zSCM9y3Z1bx2kgvkN/M37P2uZU3fuTyjQwEzSxzBwJeBz?=
 =?us-ascii?Q?yOc9ZBo524xv69aFddCRpaMNKHv0RdQhyUSxBYAaLWl6uRnQugKFjHTRURgP?=
 =?us-ascii?Q?+DovbPiRd4HphqfdnBSBT5gPBmapPMlP0xR9eXz5cR3vt9G7aC2bKeCVw+5n?=
 =?us-ascii?Q?5e8ysMQjtiTnZPOvEcdELx9eg9Ws+xNwnkG4g+ao9ETHXanU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00731ed5-fd8b-4d9d-cf5d-08df2eb3cb07
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 14:09:45.1097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b0/fzE02P456IsXRnIUoxWq7jQnhLycnba1Cjf+inB2OpAFE7rqieT3Gsr6Gmouk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7978

On Tue, Oct 20, 2026 at 12:51:26PM +0100, Ryan Roberts wrote:
> > However.. you still have to affirm which single mm is the mm that the
> > device is going to be doing DMA against. The process the opens the fd
> > should not be forced to be the mm that it gets linked to.
> 
> What is the mm representing here? Ultimately we want to install the KVM
> instance's stage2 pgtables and (pinned) VMID. We currently get that via the
> bound KVM instance (which looks like it still works using the cdev interface?)
> 
> The guest will then install the stage1 pgtables and (pinned) ASID associated
> with the relevant (guest) mm_struct.
> 
> Do we _need_ an mm association in the host?

Ah.. I see, I didn't quite follow that. OK.. Ah everyone else doing
this is using iommufd with a viommu to establish their connection
between device an KVM. eg Jacob Pan's series. That's a probably a
better idea to stay aligned with the common path. Though your reasons
are a little different..

If you manage to get pinned VMID out of KVM then we can implement SMMU
BTM as well!

Jason
