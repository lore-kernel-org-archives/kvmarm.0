Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013063.outbound.protection.outlook.com [40.107.162.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D521A3FD147
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783336497; cv=fail; b=XG7UJvNn+o/S5kORqFG2cycZlVocxiOfiJ595iB21+2WpdFDFco2Q66OkTOPBv17ilR1ixzzVR5QG6geDST4/jbx817LAA3S00b+uhRAcWD1+/Jp1cl9qshTafaFJQG3Zlbd+ni/ChFZ+vSCTjMBXtpNVri2amsHnpW5s3tkKvA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783336497; c=relaxed/simple;
	bh=5sgfrtC6euyHQ+jCRInld4njc9CLE7w9D+8ACclAhE4=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cz2kD/UbDYGpbBwEYfdZFoHba1THlSZJrurPnPbZw/A2QhRPLFZjTBlDKo2IEfMk/3PH1LEArQBMC2vqhDuoyiGMK2qV7mLMV3edWwAkuskHL/PD/0AnIozaXfA92s6WA48ron+3LLZ3hzo8eoE9WDapi/26D4+aleuMy0lWxI8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cZxDS7NV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cZxDS7NV; arc=fail smtp.client-ip=40.107.162.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cZxDS7NV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cZxDS7NV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=u11bRJ0beruCxBJO4bhtTz47sAJ3qdXMxAOTFHLUgM1DR2AKMir5D0yKz80vOLtE1JgBrCHW8qkZcskdHNSl13bCeo0GpuZ0+LFkZ1+m95Kf0ZQkzeRT/ODXgl+BMFrvQ9lx1MIpryAtHsVIzjdq/JiUB/x6ZHePG7/ZL9Ni2XZILlAvZ3+ZW0cH92dkWN0ZTRS2gTvaXpuS3LHFXucoiHdjFpNslJbFZCwD1LZvssw/5ogcZYYEEYcAg/b59Gh1qGg9MVIBXnCqaJgwc6rTVDhhlN5UfpHiB6Qe4F0PoGXNlciNNdD6dLQLzW4tFqF2FTL5ncYP+9CNIxBWjkPHMg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7d65Wc+aQK31EJy22CFA5aq0tav37cNiiOeHH0sjOg=;
 b=K04463oIeNhtwcEu9fPkBh3hAk/YKnR2Ms2nkHg/tVsW/zZ36Yo9XRIMVO+cbDvI4uRMotxRykHBfrRLS5g0HgWyPAOWkK/BeEQ8UgmycKnCxcuO43z1LF91t9lj4+mkF5SomNkz0oLKQQ+fifIq/HzsNrvs3VSofNyPNOzRJkDiVVuJl4Y4p9rOjTiUnuUseRerk4cMwch7dJ8r6dOmzPEXwCzU8kMQHg9txksnX6wpraEHRjOL57nZnP04Y5h5J+76/iE4VXcasqd7BlHzDH34UZ5cjofBeodtbTvLq8pEnEsyFPaw/shkoPtVPjd0//4pbYPXI0iV+cO8njUhFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7d65Wc+aQK31EJy22CFA5aq0tav37cNiiOeHH0sjOg=;
 b=cZxDS7NVQ07ynylvdYWRkOhFfIZTLcHVqas7Lw9FsGbrs6Thnrq4NJay3AZA2aY0HQSUUejeg1mmNURJuneCCnffg7qTF7Lr0UzcBjKeyc8aKkZi0OCsh4G3qBqJP/eTUkQYac8gk1PpbHhYSraNllhQlcNXyLi/G6ZJtsM07zw=
Received: from DU7P195CA0012.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::22)
 by PAWPR08MB11144.eurprd08.prod.outlook.com (2603:10a6:102:46a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 11:14:50 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:54d:cafe::a8) by DU7P195CA0012.outlook.office365.com
 (2603:10a6:10:54d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 11:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6 via
 Frontend Transport; Mon, 6 Jul 2026 11:14:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhWdmcudVBBjvX4taKacFD2E9dazw53c60bdOPXfISJvKHKArMH7BOodDWZCXcR0ATSER4wpIgBAFhd4lQ4X+K39u8jy9A0k3z002YuujtQpOxp1U+gfbPh0aHoSfY8tdwXp89mCRl5C1BoLfOksxIDoRNLszWCAbvymfPE0/E2Cj/JqBa0JDlUdRg6h6faV/yD7yv7IZ5If5Trw1U4Oh2+fRUCqm6JX7Ln8QzyTLyQaY9/6HSlB5UdOwhixnpGIyExbgNRcHU8e6YVB2ijKF3DMxwDCfiIZveR0A5tP8Bnp3+p4DOMq6GDVPP41rOJKDAe2KbGEqpFTPy0ddfp28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7d65Wc+aQK31EJy22CFA5aq0tav37cNiiOeHH0sjOg=;
 b=kG9WyV8W72y4umeiGwcSLr563gYF43cYBdvH9vi0jBhwnI+HM9WazzlnwiNVtR9GQxqo7HSLV4PzLJThULgS6QeHxBIiCOg7gXDHL40+h58oZh/8ziRXBqfPWRx3/khejPe+vMQIhPdvZN8g61gLv0/D4IGwzQzKbbNu9s1shk99kvweJ233ysF685WAmXk2yxjxsjxOj/9toa5yA7bv1/slHi/c8cU+rEUjdRglhQOVibb6p+6qtDIPFj0az9BMPpu6bqsv6dcuji7ceTcict+KyjuMAn5gkViskJ6cgMKzqPDN7qI52vE3EfIfyO4iOweSzcD96Ce1OY0VkGMq9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7d65Wc+aQK31EJy22CFA5aq0tav37cNiiOeHH0sjOg=;
 b=cZxDS7NVQ07ynylvdYWRkOhFfIZTLcHVqas7Lw9FsGbrs6Thnrq4NJay3AZA2aY0HQSUUejeg1mmNURJuneCCnffg7qTF7Lr0UzcBjKeyc8aKkZi0OCsh4G3qBqJP/eTUkQYac8gk1PpbHhYSraNllhQlcNXyLi/G6ZJtsM07zw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AS1PR08MB7563.eurprd08.prod.outlook.com (2603:10a6:20b:472::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 11:13:46 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 11:13:46 +0000
Message-ID: <ab60e6a1-e59a-4089-a6d4-386b83627b87@arm.com>
Date: Mon, 6 Jul 2026 12:13:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 4/5] Add guest_memfd support to
 kvm__register_mem()
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-5-fuad.tabba@linux.dev>
 <5a699a28-07ce-4a6c-bc41-8b9bc7ca0d4a@arm.com>
Content-Language: en-US
In-Reply-To: <5a699a28-07ce-4a6c-bc41-8b9bc7ca0d4a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::8) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AS1PR08MB7563:EE_|DU6PEPF00009528:EE_|PAWPR08MB11144:EE_
X-MS-Office365-Filtering-Correlation-Id: cbaf9c92-487a-4f83-9b15-08dedb4fcb97
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|4143699003|11063799006|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 xuNNU6xHD0Gzp4RO1z4mHKwNNkORLJO4xbfxI3foUzHhwHjkUNfyTBypzlabqLrSw2QKyiYS6iAsuUCQwTdXnrU8HOst726uMMveW81HKVizLZ9ER4mX73EDpJ7dJQgLpyk4WnzMC3UGGZa009tPnLdTyWOBEj2w9cOAtGeY+0jG+F+Zr1algIufItdwM6FH1lY3H98eXUQT8b5UNX1uING3SwrUh4NYjXPEAxxIz8y5TBAqZQsD/ffIPHdmmmN310OuM+iBJgxGRbnUdxTBDyWjGLoLdAQdgXFqqIViaWGkFUSJd+0dtA12tm7dS9OzvpdbmmBGH3yajPWC7uXq3HzhQoHRqfMgpvo53ztZywbgUt/Ajk5wqev6sjzUT8ws/qxUl6zXg2Mh+udzgmbrhbkY0kzBxIbihoTh30ZTBXcDMgoM+RCT+PicHKXJqbS9wtYKc2/fc0/UTLYku2tFu/OdyD+uNudOHcK7ABlUqXe3fbRM8m1D+y0YeCJf6ptCsg73f6JQQExCZUHkx4QCtpYSVyYIHhdig8V5TOJssCpOSslo4uqszc/xtzWEsZQTWo+hMWoBtaKexwqEPDj5POVwyigFBTq2T6hPZYXo6NLYU6QdBW0BrwedzYpqBZgMxDjTF7DPUwoIgsYS+XMsX9Sv1Yfbg0y9vaZ7nc7Rfvk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 rIxx2ToEjNpUBxu2u8Mo1XCXW4a7M6FDxq+wBYCG3bYScKtdM69J50Z0KbznrmpSEUjFvwdLhAB8vEytJKnOfhPqNNIYtcOol4W56W8lXh2QXPo2ANEObcXhymqgYel2xdp3yAV7KcgpjbbAVwCnz1jIwk3LLEpTF60PKSwdfqAgnzlQ1lG9+VtYuN0Xo47ZWxI8sOFxbx6QbqKu45Vx5xyTRaQKLhe+UrT8jYWXgJX8EKIrQUf0G7luTlP0ZrtwpL9BkFp7uJR1gciAbzHJlAo3DNTo26DMGdKCF2tKGp5gGlcjs+aO9ETALSO5T2iQ/mdNYA8LJP0dUVQ08dA9rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7563
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	79d591f9-da3c-4756-994b-08dedb4fa5b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|376014|1800799024|35042699022|82310400026|23010399003|4143699003|56012099006|18002099003|11063799006|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rFQWZG+YDlsv1qKHjgr4tDiYQrhX6caOkiqefX2Mcxla9Ww0lCppQ2NQ7K4Cu4OkKMzEOUgJg3/cSo9Z1lSUWWOft+yItihUYMYCycn4Ex3tuRw/lawnVcQNbYIsoYCIsM6D//L7ZXvljtZPYtslgW3xx8MJmddsHHDYvT/AYY3xiFv4rC1J16vQkm7zPaSp6/p8RBnOlCh7bVUnjpjnoZvi1gSdP9XQvVnM82kypcITKUXiYh76YWtIE3l25e7VkRK3/JOgkerP7WvoW7wCwKSG4mxYgLIZYiyQqf6AJV4mSQy1AQcJLQTx4NpkPNJZvf539LbuuJHzZteKECIelgphDDVIvkGfh/o5+2mTeMn42/6m9pywIHCcG2Y1+b23PVY+YFNLV3MkfhcPSfSpK+I1S4NaiBI8z+LVxAIY7sJNorTW2uYnGkfkndnC+R4vJASowYWfY4Iy+FE8ccUCrs6mm72xN/W4LtmdRMLw7fMbBm/etfZys1Fjzf9eyDnUluP61sT8wYsAHdRVfBOXmmW4Fi26UBN8PcunrJoLNaxql+dYGoYLhkuxF3es4jcqH2BJW70ZAtUdvI6B6EZbhNg8hitGoHqlktQlLdClCX8VDVzxM6PE0diqJGZBw3YYmmAQhhYA2tv9J3BwRmmg40jIKSllnWw0YPVfR0Ui8sqw8B67YlNpC7Z+TYfAIjtXxgzS0x9sb3f4SnCpY7oOYg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(376014)(1800799024)(35042699022)(82310400026)(23010399003)(4143699003)(56012099006)(18002099003)(11063799006)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZG7EcaH5kYuumTQJ5Hm5bgskvBpD5+DZxJuaKeMpVtqb8vgQNk3wWV0iLBa5LiZiP9xdTVIdJX02ZQMox4Lllxe+lc6dcA/mWGySYT+ZLQd7UiAvuPk0mq4OdET5XoIf4pRgBggW7uscYIDXvrrRxeQRdUv5WeXh6GN4yomfqbpDh9CtYBtPZle8Er3zo2827LicTSdFbrvoUtG9UlHA5n6m4Z+WKM7icj8SCx7MKWjE2ugwtMhYNz/6Rzfzu2vXHs9vGVzitl1+tveZ0G+D0XNlRVUOkkXxO7ltEIZt7rIMLh0ny80/f5I02UJ+Myq3rTq+LLZy+8gmGfC9967WR0bQsGl9aXepg1uJNgaoprX5WU8VHEKoCzesSSWjfut0cHHQbSOh8l8n9ic2lJnNfQz3doQKoYWmWKPi5JhZU1cnXLpwE++nsTPMZ7tkaUnX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:14:49.6657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbaf9c92-487a-4f83-9b15-08dedb4fcb97
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11144



On 06/07/2026 12:00, Suzuki K Poulose wrote:
> On 06/07/2026 09:35, Fuad Tabba wrote:
>> Add a guest_memfd file descriptor and offset to kvm__register_mem().
>> When guest_memfd >=3D 0, set KVM_MEM_GUEST_MEMFD and populate the
>> guest_memfd fields, binding the memslot to the file. This prepares
>> for backing guest RAM with guest_memfd on arm64.
>>
>> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
> Looks good to me
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Having another look... Thought of adding my comment, no changes to the
above.


>>   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>> -              void *userspace_addr, enum kvm_mem_type type)
>> +              void *userspace_addr, int guest_memfd,
>> +              u64 guest_memfd_offset, enum kvm_mem_type type)
>>   {
>>       struct kvm_mem_bank *merged =3D NULL;
>>       struct kvm_mem_bank *bank;
>> @@ -327,6 +328,12 @@ int kvm__register_mem(struct kvm *kvm, u64
>> guest_phys, u64 size,
>>               .userspace_addr        =3D (unsigned long)userspace_addr,
>>           };
>> +        if (guest_memfd >=3D 0) {
>> +            mem.flags    |=3D KVM_MEM_GUEST_MEMFD;
>> +            mem.guest_memfd        =3D guest_memfd;
>> +            mem.guest_memfd_offset    =3D guest_memfd_offset;
>> +        }

It may be worth capturing the fd and the offset in the mem_bank here,
but agree that can be added on the need basis and there are no users
of it for now, without conversion support.

Suzuki


>> +
>>           ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
>>           if (ret < 0) {
>>               ret =3D -errno;
>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
