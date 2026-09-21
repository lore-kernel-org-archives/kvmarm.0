Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6D4377010
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994333; cv=fail; b=QJb5L9MJtcSScJHbLkzV/zKIqrehCBTjfyOhMJGGW3HYkaeBhLVQSWyKpKNHiG7xKnykKyNwAWVtvhESRfIs7cx+k9zgO4vvrjnAm2mmDUwRiUO6w2hY5oav/BFQx5foxAH+VDbNPFkj+EhLkEFgObM1p7TQW57CKDMkr3w7pEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994333; c=relaxed/simple;
	bh=ZoYpsF2HoHSUKilJ0YxtjamXfxGND9Z2/3OawV4jQqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oe/sUfzQuSA/58HjO5bywUG+v+VQzZ9r4VBiXF2+6f6JEmgXjNozHXGzGZV31xM5eQjl+2P+OKEcfz5VukWWwn2Ro2GBF1cYTYDx6DSeqN4mD2wbQbgU2PtfO7Q6lrIJ0EDq+BXRidZXxnRjFmm0MwvPhojQP3DgQBXNJ1rwMb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uK7AuUin; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WHH1Qsu9; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uK7AuUin";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WHH1Qsu9"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpH857563;
	Mon, 21 Sep 2026 05:33:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=amuK7SIOpeJdADD8riM/uoN6K80xfcVqQn1k+3NgK
	jc=; b=uK7AuUinPJc6S3EX5JDoa+0CgLYmfo8pnKio2x09d7Si687znltygNTKx
	0NGOx82ihMVfRTifZWxyI4unE2uJ3tXN0y1JZ8uJ72g2IGadHAxlcJ08j3vE6xpN
	yff/oWuLBUhg1xIH4RUpVdJDQjC8+Jf1Ty6x7dTEiYEms5nz1Epuayp387uZzRh9
	CrRN9L8b+d6l6xFvIIEXZpN6D/XWVPIZTx/gkVSsyXuHZxMQTNFewqLucgzK74Nf
	P1AqYucdxm76mbXZjJGanRaMo+QXM3hkvqb+GAnbL45oVtXLLDD/HTWwwF6xzcfP
	xew2aump9FvxJ6Ir2+kUqoBh0rkww==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023104.outbound.protection.outlook.com [40.107.201.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnu-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3NVJq82P71WqnwLifA65YzdJRRCVnxqxF94YAA/48opKsBovTE5wFCRZFyZ97yboGAI+wVI55a2dJwe7Vn+1WejzpifyW4B8yXpWRH1PaKS/+imZuV5RI05S1xxaj9PmXuAKO8jCVng71MqUA61tdRC7MtgutCelivZ6CMAaGDnJJwQO56FURiccqFYGAFU12dXrifAOyqoKfXajK6tSUFllC8T/jLY0bbNQgfkaFLn/n77uJ7B8sMgJwNNJlvnpF4b+FQRJqyhbB1+xiUE7BRTtocBjnzmwia0HdaiuXHYXKWb0d9mIKsHy6oUnTht8/I6ONntd05pRWhkdaCHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amuK7SIOpeJdADD8riM/uoN6K80xfcVqQn1k+3NgKjc=;
 b=fIm3laSD8iQFw7/i/dVarc2uiCkU+goA1lHSnJ01eXOfSAJAO6vf1/SJZB9EpFQ14G5QwBX7BY6LJLHpMC2zTL9C92wInHwIvc9dEI3XnA3RLqvWiunhnBhksu/8KIldsrKqAfle7QgZ1RxcFyvJZDCNZtW/wtIf/HBTy2hDtep3pxLmHVnD/pkp4BM31K/oV/SWxahp9jTsSN/9fZ6bhsgojyrq51o2TfmBk0ibo1Ckl2jxWbkrP3RpOWgDMeu/oaFga6Q+T63BTfDJiRv3dNh4xaaCXKz0cXpJBclLKaNj0fHITByu09/1pOng8lqIukVcUN3K80gkQOZrxk4VKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amuK7SIOpeJdADD8riM/uoN6K80xfcVqQn1k+3NgKjc=;
 b=WHH1Qsu9cMQrS/oaf8C+n2dppiPH+luhX+XOYx8+aqz/uZz1CSW7PGR0FQQ5OSI3a1Pk2yPBibVVuQGm5je0sAucX/zci436OuIjdcAb7e6hrFp1NEnwVW4w65VvScXgMPTkaCu0O1wYv/c+Np+aMEphpN5eU/5nSNf5wSSTCGhYU/RquLSzyG08b/bm3vSxc7d1F1mgGJy+tUniybfnB9P0SD304pJdkFVOtn8CM3z01GozK0CfMAi2w5PioBEjAJt5N8vCu7dmraNBLqAFl/bYgl0pD3BbGnjffFN7Krr2nm4Kjse+TWLpazQlmgwV/12oHAJPAnkgxsFjRfiGmw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:25 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:25 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 05/25] target/arm/kvm: read all ID registers from KVM
Date: Mon, 21 Sep 2026 12:32:29 +0000
Message-ID: <20260921123249.1708067-6-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: f244b11e-2843-4447-e784-08df17dc8803
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	xx9h+nPUC0DmTWQPVr9bDnpNKms2DmVjb1ei3SpoJK8uNd3xB4ewH9la1Hfu1dIRbJjmakQ9lwFuFyhl1tEXMrIZTm6RqDcYjj77sbifPXTvr9xlZPu3CEhWPi07r0LW1yVSSsZtS6C1RIP4X2VEipnWnG618XS63YGWvAAYtjoz/KoPRV59pbt26srQyvNXqyibsBNAVP70slKxUsrqTttUegZwGnrKMa1qlhJcMvMv5xXNAUvqMKig87rkxIRDCORx3gftdKTtFYWtlDMHCvQqFEhwBaTES6LabjCkgyVIAOLQ6DrzYMvqjQ8N/aeiN93JlMZ48HAY+9mner+cnZxORZNSNggloovID/wE2ah9G6ihatvN/ehdatPwdPT/xvDNwEAypffMQ08grj7stfaUIgFG9Nf875Pq8VZyIh44VS/MbG2iJr25QKiuByZuE2oC5Q6VtwLKmwhduWnoOVVKUjnEqx+/LucFa62BfldYA/pgpLeJ8ANm/s4MO5f/A9rMNQfg+pv4Ne6AsMd7uRdmplSGVI6WE2sm1AFZrCpIuLN3N2yNC7Vjdv1ZLjuSGPy5SCaBncrnMl8Amk/5P15Pf7Em9f77F3gkuguyBd6ROypCtVW9+95PAlO+/cms0p9qimFwmx6AyCwuWxijGHXuIMhO3vujLiVqR5D28N8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d8KLq7XUZsP8embRu/6eeChwioz90FXd+Q1QkBdBbg++UvSmYfiQxyrWFqhL?=
 =?us-ascii?Q?VVw3i+674w50zO7e7JnI8joToqlrxhDIEVu/+rGzwShwxH1AJ+IXont07Cmw?=
 =?us-ascii?Q?gX6P+TiKFRcRnPK7gilw9oM9C0jJCaHckmNqTjGNyLlwdpHc0dWUQJbe0K/P?=
 =?us-ascii?Q?tEcmF0tbVcz4WzQ09hk+bCzLZdQyxKfBwJA/TsKu7ziL3+9NmnvNLbF8h1pS?=
 =?us-ascii?Q?FLBuTHdJn15djkYSvXK6ZNBI4Ed1enZ04rrO9NFZt21BBm2kbEpGVVDJwOxL?=
 =?us-ascii?Q?rRS/0yCpxmsc2v2hQFIViLAqV/TX++GLoDCBHTKVrBnUNTSrFK6EbsfQbDeV?=
 =?us-ascii?Q?YAnIw4T+racwDbKxi7KCm+BkiUnM8xK2dZGx2WWi5KTIAITSGK4Ky/q+6sux?=
 =?us-ascii?Q?Yx7YC9mHi3odaG9Cw65bYFRGB9bvZWZI9ikBS5GQBKtEGGCoRiPzCEh+mCeu?=
 =?us-ascii?Q?xGqd8/SYUxr0WNskEVZu2C8aCbqcqx1Jof6Ga/rLkgagjSj/1ntTAvg0pv/M?=
 =?us-ascii?Q?hRGPtjRaf/ebqe21yU/Ezw47i9bch7+sf4PoMRKm5vDwIbs9kNk6mOF/c+y8?=
 =?us-ascii?Q?MgGDM/9SiX3a2vezi8BLIrx76UQsz6dBKMLixx2labZF+jyZkPDthZUY3Be/?=
 =?us-ascii?Q?L6l6w1RiExFMZmHuD32HAoqOdujbF1BGRlfu8PKqBwpt2YAKhA/GlJ5GnEuy?=
 =?us-ascii?Q?oowmQLVTI+X7ZGTym045JbdOUZ31gN+l7Aj+wlsg+ZbncZBUytv6rjm8GzhX?=
 =?us-ascii?Q?RFuhlrZz9Rmofspy4jZSgtb/70gxNQ3uXTZvak6Zu6w2NmbMlVhYRyCL/bgv?=
 =?us-ascii?Q?GJllpf7pc6KA+2I/AnH1zKzYVEImORJgdtmbMY2PeHHp1ExDyNJoBcsLBWWh?=
 =?us-ascii?Q?EoWf9iGfTrCphdUpEOiaGdIYHVURy0r4104dqG/dXlhdUShl3eeIkoQ2+X9W?=
 =?us-ascii?Q?PHUpRUI/qeNQ+EKMJTH/gNXTgnCGPr2Ha2xiZYRPAA5DfNQJPgL0g5AA7cN/?=
 =?us-ascii?Q?7iTSlIdx0wJpiDq4XY/zR8iNOhSwqVaUpgUDrkTHVcASdCSHXzBpBRCVgkZW?=
 =?us-ascii?Q?i4zGfUh0lHtT1VfKWAZcL4+oEec0PFJ3XIs7eOOVjKmB7mavv5QDFHa3kvwK?=
 =?us-ascii?Q?CCAdv2tvWyLVb0H3WQmuDDA/wze/WOaz2cVu5wPDzJB8PQqtg62OIg8BuWV7?=
 =?us-ascii?Q?O19sypWlIJ0NRE6FdcunVoYQmK834ldzYACapSoC62BmLTnYx4mk8cU0YCjB?=
 =?us-ascii?Q?57npwitbKMx7YbNYuG6Jkxrm1YWXPRH3NRfKKP7N3o1LQ8s8LRThZSrhambD?=
 =?us-ascii?Q?fUXO83hnbjBwyGCDCv1WgbnkPA2BpQTMKZC1+P+GKKP04FJAcWETwEG/0y2K?=
 =?us-ascii?Q?LP4yw+6O2lilw4mWfDyigf3X6LfYeZRCbZSpJclV6HM7tyFEgcRDnVGEWNyX?=
 =?us-ascii?Q?OMUC54zHjl2tsPOxcy/1uUiTVIhS5v6PCEuTU9HaYxst81OBJrCO8u7HFsqL?=
 =?us-ascii?Q?C/NfJvPZiQqmzQ0aV4goLWu+w+SnXTSNLtRaQdCEtWR/b+S8GtejIiT/oXxX?=
 =?us-ascii?Q?he182j9X84e0PpI+TY4TXb0CSg69rSkWz26IT7wR0SgwJsOJHSPHBdhq0Ahh?=
 =?us-ascii?Q?WyazJUD9MdJ7gLKO/OK3HOsQhZGJkXYD5ukq4fQJ6H2FZnLM3sumZ4InvK8C?=
 =?us-ascii?Q?zmUTL2nlCfkIXVjzZ3AyNPWlh4y2cSGzwa8w7Hcv4F9PoLktOAx15I07UcB5?=
 =?us-ascii?Q?fWUuWaLkEN8yactEHu7r3umBL6nYydY=3D?=
X-Exchange-RoutingPolicyChecked:
	MrXwu7osFVRWV6lKfV9BN62y3fuOhiQfN8+UsMg8P4ZzcG8Z3CudSLohLE+6HJm0NO7pWfE359khQMEjnKpbaNtBFsvGdz1jk678ACVqz3c99V0gdBpxt56sLm0lQ35fwiLdjF7w2p11sJ4O7HhelIK3KZC+dxg31YRHiQp/7i5+2Z/mypcK4nryJIvcNNDK8WLhNTtqekQir/MEZlfMPG8GFTCAqNZy7xxPEV0koSvDaa0ehdzU9bL1CrKgc2m8n7rdUcSe/CAD3IU6bPRMG3rfESvqPYdB/xrYCqLF2BiwwbA+QYvsPf9uuOEz18/8VXJK+REQRBOz69s3za70yQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f244b11e-2843-4447-e784-08df17dc8803
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:25.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sO4n4zQGO+tOM7mAAh/dLhLaYo9qQTCufRy1KQGFZ4E6de20iR/UDa1ZoPvUOTimtgMawr8xLD/wM+rSwqLyK7F5jMF8YDuH7n6SQ/9QE78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab12420 cx=c_pps
 a=0aASrZ1Sr5nz2ag1/hSaPw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=F70P-8mHmDy_4NvVqAIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXzao6ZFWBIIdt
 u1nBaqbYFKvcyorYoUr7uXQ6TmnnshBuM3cZ1eCVvs7i2XjqOCgzFMSc9ex+0C1A7jbhufNXExk
 rbNauylI5TW3ERtIHdJdDYibMpDbXKs=
X-Proofpoint-GUID: zjau6AzOFaxA7YcwoPpccn8owkHTLuFW
X-Proofpoint-ORIG-GUID: zjau6AzOFaxA7YcwoPpccn8owkHTLuFW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX9hLE0s9lniXo
 7jpMHssk9tbU9bBMa3IOoO1PLX2Q+eTXN7BIm0T48Osl7vBlSOqRhDusbQkyPmKce0gAbe0OOL3
 jVMR2ipRGLjVA8ofhBPmvF8MVTjuUwJIGsLDINyKX0FM66hreKa//utrBzjY2Cc4YZSEJPMW4lF
 q9e18L20tLvvhV/MVESpsUgjnXsr/R9Sol0gVa+CGmE667zuPMAxYwlMitagXvZMzjlTj/vfQYi
 +G8zV4iZKwJEG6EnOYSr9vPlDM0fmVJgdD9whzUp/TrqbFJI7uFxfprXAX5JgfKsW9Bosl+lchP
 qrm/iRrG2JpezDS63xQzLAWgexBNo4fQIeYC2U8EY9iJ1uE0X/Hu5AtXyaUmSqEHQgbcBgaUNJ+
 GW65rOXe6EOIzSFeXdKs6m8LP4tsLvMIkG2i76utv7glPxFkiGwtHqsoMHRS/SfzG7sO5aHZ9Io
 ZMKliU1XMDcjiakLbgg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Try to read all ID registers from KVM. KVM may return ENOENT for
registers that it does not support reading from userspace; ignore
those registers. Some registers may still require special handling.

This exposes a more complete host feature view to the management
stack. For migration, both writable and non-writable ID registers
must match.

Add a tracepoint for ID register reads that fail with ENOENT.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c        | 29 ++++++++++++++---------------
 target/arm/trace-events |  1 +
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f8d349a461..d9d0623a2a 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -330,12 +330,12 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
 }
 
 /*
- * get_host_cpu_idregs: Read all the writable ID reg host values
+ * get_host_cpu_idregs: Read all the ID reg host values
  *
- * Need to be called once the writable mask has been populated
- * Note we may want to read all the known id regs but some of them are not
- * writable and return an error, hence the choice of reading only those which
- * are writable. Those are also readable!
+ * We currently try to read all the registers. If the read fails with
+ * ENOENT (KVM does not identify the ID register) ignore it.
+ * Some of the registers that errored with ENOENT will anyway need special
+ * handling.
  */
 static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
 {
@@ -348,19 +348,18 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
         uint64_t *reg;
         int ret;
 
-        if (!sysregdesc->writable_mask) {
-            continue;
-        }
-
         reg = &ahcf->isar.idregs[i];
         ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
-        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
         if (ret) {
-            error_report("%s error reading value of host %s register (%m)",
-                         __func__, sysregdesc->name);
-
-            err = ret;
+            if (errno == ENOENT) {
+                trace_get_host_cpu_idreg_not_found(sysregdesc->name);
+            } else {
+                error_report("%s error reading value of host %s register"
+                            " (%m)", __func__, sysregdesc->name);
+                err = ret;
+            }
         }
+        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
     }
     return err;
 }
@@ -482,7 +481,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
-        /* Make sure all writable ID reg values are initialized */
+        /* Try to read all the ID registers */
         err |= get_host_cpu_idregs(fd, ahcf);
 
         /*
diff --git a/target/arm/trace-events b/target/arm/trace-events
index bbf2e5dfa2..2bb7766f7f 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
+get_host_cpu_idreg_not_found(const char *name) "host %s register not readable from KVM"
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
 kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
-- 
2.52.0

