Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013006.outbound.protection.outlook.com [40.107.159.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1081F438036
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951469; cv=fail; b=lnEhJp3h3gO1F4340EHanKzwkLqTcj5y6QqVqKLMOzYkEWALZPG0ODezcjWQrrD9lR076OwVcokVg2GWZl1oMxndAZ2EydweLBa1BIFylW9mSNwQ/cHlaPvc28tdmqz7zbB17r4kxi6YN3lwAj5R+/3lqu9T3EX2DFJU9ECv3UA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951469; c=relaxed/simple;
	bh=8gKvo6Li3xMNikvmXp5GKHQcXzyM+2MyTGXDz4fM3e4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sz1rGphQwqtxapKgR7POg1mUmiyFHGle0jJS5LaOJLgPTZ0Axl0CYSVaTyLkTW90Ie1+A6bQSsxVgQdMhB03cprNB6IVWkfXAjX3U8zRrgUvqG5Y2DbNCw1vKzdOCSJxhZnf+1RxXLfRDKauH6E1l+/7cctGSEN2WYEO0exs7HU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F71KFR82; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F71KFR82; arc=fail smtp.client-ip=40.107.159.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F71KFR82";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F71KFR82"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=efnrYEMnmSlFrdRCVyRETDxWV/nT3zOP641GIfYqx0PgKRIu0ix9FnIS+l4vHOBg0FJNAL1a1DqqbVhngc3Wak9ZOn5dyUR09G3cRGuAnRykatDy+g2bUbLivzpG4bBlomEVnaHgNEiwdLgiCXGaSks4N4OtbcNwkJQJSTh9tbD+dz1hS5VqnM046bHFeMPHGMbCIz1IkgYDSza/6IDcyqRmmspLbecpP9Fc/6oOeqDpeAfROG0ngzXxquVKfbV4Tveh74gcs1dwmUXZN0pBBsNZtg9g5QdNMk1hT7EAg2Ytc0tj731m2kFAQOm1ES/4k8VnKuFcEL3MSZX/jsD1Tg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQnJjZw+4z9nghA+zmLmUfPytA2LMSb8lumpj0YBR8c=;
 b=uJgfW/t67ai5wtJVa/rtNACgxDG3fwtKw+2EEMdbjLn8IZxVMyH/v8LFDueRGgDKKrHmNXIycQaWcCDqZOqoXvq8RJ/1CywLLenXeFqGJndqtWkcwhH+lOuS/QYfEom37OVrSFacIrN7gbGQKVUBcGqwkiP1/E0USP6Nvxm550ggpLhsWOP8W8kZH3udjzx08uAkZsVzzfqVlrgJizAWNQg42GWMtd67cGM0nNkPb8ss3egJ/37D4UfTaOvJyjw0PG9aWZI+Mqd3Vll7BNhOvE629U9G5vjg5dxTF7ejfWgft/7svyFGMOz3K42VCpa8JrYB/9ccyibGPZrOGNPG1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQnJjZw+4z9nghA+zmLmUfPytA2LMSb8lumpj0YBR8c=;
 b=F71KFR82TJ++HKsQJaxGWDC7OygBOXJ3ZY4t2vAepexDPsvouGJn6J9/6AilmOl7r39/U0Y4n9O+Py901Kjy6qeBpLLJEmJ16IhzprrAu50VTNhPKrzehG0Z7h9D2C+bq3YaGkvXZImvjz+VOZzSmUVoPCm5gxNDXV88mOlBtN4=
Received: from AM0PR10CA0006.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::16)
 by PR3PR08MB5593.eurprd08.prod.outlook.com (2603:10a6:102:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 14:04:22 +0000
Received: from AM2PEPF0001C713.eurprd05.prod.outlook.com
 (2603:10a6:208:17c:cafe::2c) by AM0PR10CA0006.outlook.office365.com
 (2603:10a6:208:17c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Mon,
 13 Jul 2026 14:04:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C713.mail.protection.outlook.com (10.167.16.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Mon, 13 Jul 2026 14:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSiEJuYl9zH6WaWEeCrsjuBFvbjXb8pkrhFNY4sm7uSv1yAcgQj8J0eEqtm/VWmkhrpourmRzZnFWvS3zO2BGaPFsL/j27FxhYetXZYUzn0PzOdN/vaukziV+b/Tm4cv4MOb5cy2uTIq7lfzOJ4iDc1jKPbSApGQ4f+FdEnsBhDp1iuXVit1XQGc87QiI/EpSr7UrFknsNEY5Rmkgq6AtdxpQjpldDwWpYOUBKnA4d+tW+/nllI++QlW1E4oN3UD1DasqwzAW2lKm9/9RQ+93c7yllQtXa8wnkpC7UMzPK1ziwAhRfZgAuw08y50biynEy4H+pUzWraJ2K3RdDkrmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQnJjZw+4z9nghA+zmLmUfPytA2LMSb8lumpj0YBR8c=;
 b=aSHgzWh/uyWcAp+SfhvpSOUon/jUfSJ9YWwC2o/ZMVAiNrB1fYQ4Ef8N8PMBZ51BE/chnLR1QdsaiGzkZBZiGHti2mxD0a+1DJfSpKoOvWDst5K/Rp5exhvQT2q6SzCOtE6pKgNKbkH16tJjqTYeZbqWpgLmRtN86hYvAZHwA38yF/GTmdcBl6BaSLVGVbQc5AKdFgwBXz6gEBHXWX/dG58Toop0ENHWDWmue8heo3evdaDhPe8QrgXziWN7r4XBSdf1RadF1sX1yXDCLJWc3exU0jCAgrsUVscAc/Ecjyg+o0Z3Gf5L6kET3p1tma5hlQhQrtkORztpas7bOoyzKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQnJjZw+4z9nghA+zmLmUfPytA2LMSb8lumpj0YBR8c=;
 b=F71KFR82TJ++HKsQJaxGWDC7OygBOXJ3ZY4t2vAepexDPsvouGJn6J9/6AilmOl7r39/U0Y4n9O+Py901Kjy6qeBpLLJEmJ16IhzprrAu50VTNhPKrzehG0Z7h9D2C+bq3YaGkvXZImvjz+VOZzSmUVoPCm5gxNDXV88mOlBtN4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by AS2PR08MB9619.eurprd08.prod.outlook.com (2603:10a6:20b:608::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 14:03:19 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0202.018; Mon, 13 Jul 2026
 14:03:19 +0000
Message-ID: <8c0c099d-47aa-4bf0-ab7a-c682b0dccdf5@arm.com>
Date: Mon, 13 Jul 2026 16:03:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev, mark.rutland@arm.com
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
 <akwhexqW66RK5Gru@google.com> <ak0x0QIWWw6lFUiy@raptor>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <ak0x0QIWWw6lFUiy@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::7) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|AS2PR08MB9619:EE_|AM2PEPF0001C713:EE_|PR3PR08MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d42fa0e-b981-4fb8-7047-08dee0e7a393
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 mPTs/bE4H7wvSsqdX909+PkUC2YLDGue2PPpr0EVq3Q6N0Lv0BMdCZsPHtcedhJj0GbrXOe1FdGjsDoLdNt9CsOKlFkKkq73wtUu8E/OuYvibr2WoDkB47znnrkyUTNds+t2n13bZra1t1yFjo3ITD4arYskykldXhYeny6h7vkt0guOvAz33FODZFe1LPqbvkmDrD8AgJHh6CczuwnkHVP55NMTJa57onvOfxbmjP2zISp4PAYN0LDLqOKUB9+UW3DkVjG7BWUKS0cX25re/d5Zy3edWbcLIog9CseURkX8uABuoayuckWedS0QLvU3bZp5ShdZeYfFVIpVNzx6mdwduGU7VRP5J2ICd2rl4u2DhIuMuMDEO30gkzu0jK2qRHEpD1rzOt5BSkngdywXk6Gyq2mLDd4hZxQ3NnefZB7gPTOMHIL2SSn44QVVz7LecKUmKG3E5nulCBA4HxH4VzcXf+yQn1RhHBoNmZNj3mHkNTplPHWC3Q3Bxe43Zlb42SSag6ye5B4hvgbpq1keRJG2byxtmkOScHuKlfHVDYVDrnRjq7KenCk802uHkwEn0wZSpeBtyDcQIs/hD7nxV3L+YGABFq7PY1zgHkiltgG2M+ySLHACGprM3UMG+y1W3C7LBxyujaHC3VO4ROxhry9M8+Xbr4EX0qH0DQL8IiA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 T2klz/5OiraKbt6M2wgHsGorc1ML3q1V7Ma/a4CF3RKDEve+EDGpkyVZRkGJmyjE1CoS9kbGr9LVttVcNHySaNx5L0TIHFJ/ErxmC/6HgiDyaKVNpi3aNivN2UMaoaZm+4zO82d10Wk7I1LbHfkWFIPAc60vPJo5IQc25RSy73iGON1WDwSHW/WRshZpwFzsP4PXGkW+olkpunmnp/q9rUPHttI5wUXfDaD3mRYh0DuQtmAKE2Gh5ymPJVYVN3VAJEgYcjH9NIx3KviJFC8bLRgxpydHANXQT1WXbmMW27M/xRS4qnRygA2cjGsv+pOxikIhDOi+hbiA/1CnTO6sGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9619
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	283271d7-34ea-4ff3-fe1d-08dee0e77dfd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|23010399003|7416014|376014|36860700016|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VIqE7wHI0BXeNJR/P+xYuB5/vBshH2S22zlEL1ePUSxivDsmImyBLdPbfvTVgYDak0LxC/a5/IU3+BnwxZy8dw3tt68rjSn3rfxaLNOV7eVCh0mcjtYqvHTbIhWcBNuFOy39qRFdmmDPVIX2Lv7ccqIt9fTLAbA/3gcILVmOTtmZehKeGeMC7LLAv4CM+Pwc8598zoQ5Ulo2ZBw3ubIEccirotmbLKCa3dtwGxIJ4bpQoxap9Xrpq65gK35X1sur6iESm9LAx4jSj9a5eNnSy2hOyTGOSEA4xLqKZvOR8QpyM+t29Nwcd62UzhVxLR5XK1cQ2YchG44SdF8j7KT9LHkjtrpUz/S4u+ttdhhJ1s+7cd1cpoWdNRwll8ERFuiajo0EMZko26PEi2MqPZXLGYaUjhAkbYGYsw6/S+SR1pP6k20LMP3sS25OqDh3+KjdyEOSVQompyZjtq29jaWhnseNqb9ktfLV6CeXY9zAxkfF6UbjC1yUXehsmkzHxz4+oVaO5hSToIanVaTCtm6yH7pyuJUsgCeLyR027qSDt//9idaFlLCnR9aURt2INO9oVz+3HDyvXI3vjUm7sTA6bdLxQ8RL8CpjgMBwelvrW7fSkQFlXDQFDMNJmQm90jGyHrApUQb01n/vLaRcIoz8T3UfqkJWFzGt91bR6bEsoKfv2WT+IQG5+mbtmyJq+Y8sxkhCs2FaFoJdzmQaE5Df2g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(23010399003)(7416014)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KhR9zSTncAG3WhrKD43LWTcmH7RXGK2rjLeTWVqjClfznBOkFKPbmFbXDYzsgOYpYHdgFYIAAt6nbRVr4jzBJ499Hi93XgQ8GjNCatvwNhRLxD7qJhLPDl63nbT40OJIG3oYShx7me24DjU0qm4pxDRYqQO1xs2Dre4eoyfZa7wsWdnz0hlcCgnuFWjGeXGZjN52XYgf68lmcq603FGAz9/8UQLXAqX0JrTjxVeN6kRHFo+x0Zr3/vMk++OcHMzLXXmWgmi8G7kgGG1VCVekmfpvykJMmTsrSYqAEKz3Wy9ljwDGZRtZ0/td79XnAutQJCzfy4My9xCj0/+iplDuUMGWdI+IzKfozVDg2nyIG7QTdjNbSddnsfRdG8JebY6WbTyaFPhyfbMLVKiCQvq2ERctnUpGsYf8BVWKUFAJwz9P0aLne3cTnmFiPlisTfMg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 14:04:21.8625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d42fa0e-b981-4fb8-7047-08dee0e7a393
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5593

On 7/7/26 19:05, Alexandru Elisei wrote:
> Hi Sean,
> 
> On Mon, Jul 06, 2026 at 02:43:23PM -0700, Sean Christopherson wrote:
>> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
>>> To enable memslot operations, KVM maintains two arrays of memslots, and an
>>> RCU pointer to the active (in use) array. Changes are made first to the
>>> inactive array, and the RCU pointer is updated to point to the inactive
>>> array, which becomes active.
>>>
>>> The guest_memfd file maintains an xarray of pointers to memslots that use
>>> it as the memory provider. After the RCU pointer to the active memslots is
>>> updated and until SRCU is synchronized, readers can observe the old or the
>>> new value for the active array, and therefore the old or the new pointer
>>> for a given memslot.  For memslot creation or deletion that is not an issue
>>> for guest_memfd, as readers will either read the same memslot pointer saved
>>> by the guest_memfd file, or a non-existing memslot.
>>>
>>> But when changing the flags for a memslot, readers can read two different
>>> and non-NULL memslot pointers. 
>>
>> And?  Why does that matter?  KVM memslot updates aren't atomic.  Practically
>> speaking, they _can't_ be made atomic. Userspace is required to quiesce all
>> activity that must not observe inconsistent state, i.e. userspace must pause
>> (stop running) vCPUs when performing a memslot update.
> 
> Is that true when KVM_MEM_LOG_DIRTY_PAGES is toggled for a memslot?

Good point.

> 
> As far as I can tell, KVM today tolerates VCPUs running while the
> KVM_MEM_LOG_DIRTY_PAGES flags is being changed for a memslot. And by
> tolarate I mean that VCPUs that are running when the flag is changed don't
> return an error from KVM_RUN. If changing a memslot while VCPUs are running
> were fatal, I would think that KVM would want to take vcpu->mutex for all
> VCPUs to keep them from running. Or is it a case of KVM allowing userspace
> to shoot themselves in the foot if they really want it?
> 
> When the KVM_MEM_LOG_DIRTY_PAGES flags is being changed, VCPUs handling a
> guest fault can observe either the old memslot, with the old flags, or the
> new memslot, with the flag changed, but they still continue running without
> returning an error.

Staring at QEMU, kvm_log_start()+kvm_log_stop() do not call
accel_ioctl_inhibit_begin() etc.

So at least QEMU does not force VCPUs out of KVM when only updating flags.

One option would be to require user space to do that also when starting+stopping
dirty page logging. (I'd assume that should work, but it might be tricky
depending on in which context it is called from QEMU migration code -- whether
we hold the BQL)

-- 
Cheers,

David
