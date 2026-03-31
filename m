Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012044.outbound.protection.outlook.com [52.101.66.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394803F99EA
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974950; cv=fail; b=aGVRm0ZUzD/5HeVmdKFRfd1ZYrl63XH2wcodZ0zoxe+am6OSunUt5rq6ViOisldC2EaEKS/GVj/oNfRQdmVmSQaL+EUTWygfH+ISm8vN0RSAORka9Lhuoy+Vj5JJM6Bfq1TK+lIDjKj1u2lMBlozyDmRBaruzYe+w91YVk/pEkg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974950; c=relaxed/simple;
	bh=U3GDK6FnedYfw86mHvrr70Ilgqu2MSNytZNy7zBkCPQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C4CaZd6vJHw1S52u1pMA56qcVkqPtGGawTKT3xk7TQSZVDlz+NmcSeoEYliIhUMAT+BuNng4FuoPdpDjz2vEIqhli5BCqpTaxTumaQQPcRarKDKhCIMv85OAwMHTpVUK1TQsAOJ9AeK1Vs8LySgofJFPBwXBJklLL5ElkWbweSk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gutyxScW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gutyxScW; arc=fail smtp.client-ip=52.101.66.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gutyxScW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gutyxScW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KM0TSPAWYz0nXL+bL2jCZ1hIwbpYf7HOEgiGMcvoiOLu9XudY0KW0uglAjKe8GqkjL1r4XK7KyJZD+2Ld+UmcVQQmVp9Yowdza5clf0b1mv34rGbcD6Paz/DmTKEOF/xiKVvXq2m9O0xMqeIHdY2a3lA9sCS7A37riyM82QkfVrr9wLkU5cp8U9IQkIKbOk9BdAWBDRJGVncwrJ7QoYwXEcWuk+CFneGrkGlDctr6nUmSKfP7EBk/Ra3vxHerOEysrSiWRSQ89GDPrFlO0rkfJhZKL9ecXOlyHbHYXMlLXxp0YyxL9L+6bPznJTCAvQ32hA/xRdRWgefBHEfhCB9Bw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3GDK6FnedYfw86mHvrr70Ilgqu2MSNytZNy7zBkCPQ=;
 b=Jr6JNhNrtyUnSRGlEIwVTFt6cV79MJJ+pgOu77dYzjy8ubQvf+3Xd3a4lGJH+KG5K9Q94uNlKB2dkuYwwoZFzsbP/dy8paOqDcGei0bBZ8LBoUJ4TQqlgR6ib1EfHGIqkUBC8jNmd5kEjfLpS02zIW/stQZW1FsGmXgbtvePciUybXkaaqj2SwIDR7spb7OKMg40alZzRwCEVpudfrJOszAnOyRWRYRnAH2Vu9Aww1kRuE6hDKyjH8KJf2D4ivaHjbn4LkgHLA9qPypjn0iDYr7O96KM+ce0y49o5uqkWALzfx1Ky80TVMPUD+OfMp6HV5MTpYPbIGtgp2mm1anuAw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3GDK6FnedYfw86mHvrr70Ilgqu2MSNytZNy7zBkCPQ=;
 b=gutyxScWtCfjRE2Iw432mVzts8g8/8513XC3ek2xG6OebeDXQhGPM4wuhOKlH7O4OEy+YBHVzQSxKMpuYwu8Ct0YaoYbJI1pvo+Kq/mv4Tx1BmHdMgxhm8AddG4rJNPSW1cMGZVkXFSEvnL/AqkFAZVEUoxRGt7bef97EA8xckA=
Received: from AM0PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::34)
 by GV2PR08MB11520.eurprd08.prod.outlook.com (2603:10a6:150:2b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 16:35:36 +0000
Received: from AM4PEPF00027A6B.eurprd04.prod.outlook.com
 (2603:10a6:208:17c:cafe::34) by AM0PR10CA0024.outlook.office365.com
 (2603:10a6:208:17c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.27 via Frontend Transport; Tue,
 31 Mar 2026 16:35:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6B.mail.protection.outlook.com (10.167.16.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 16:35:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RpiUDxQzrLce4M8s6l2OKCAQER7LZhi+r2iuX+eAmlquOS9dVV8S55oi4e0BJF62ESwTnvyb2oTix5xOIJzjsodw/K3FyYc8QEjdqGYsSVuLJPsU3WMUOKg3oRkpin3rTcRK7iY3LjndKskpe9L64oC3LZSgLPjgYI7+l63fRJADQZF5uLyi1sZDP+7iEqgNMzQ7hr2KnWXMvfTrvUacvREmIFXHDzS2w67G80aOxzttutuQKx4lRSHJWD38/bQoccbPbE56pC9VrH/WKu1SkvJCWXTQr/74gJ2iatGRT/4TkfZu9gbEJIPAIQTDeuZXrML5oUZiOCLa5zyaoksy0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3GDK6FnedYfw86mHvrr70Ilgqu2MSNytZNy7zBkCPQ=;
 b=OPc2lXo/7PsM342JhZq4o2zQA0rS5jL/d/6pROIQs+d/ZJ8sWNnRCppjQV8uGZMH5q30SWo0d/y0NHv/ZCmmjk+UjYFht3aDIn/OZTBS5vlPs+jsfO6HYZXYrwCSWK/kzEmmJuhmZ/x/NQbCm7zmj9I+7T6wN0Kz+OhnI8vNKAVQ7hbhx82Z8CQAvdORKOvHMWmgWt6xEBfhnDBGzE85VthtdHEXGZSEVg506YhJSJY7hntbv+8ExWs5Fww+iG68Yp9khwSpGYt/48pVIpT1XXbgLePA+ILlA7IlsG4Xov9rGBDNNgwDzziVAwXwESVJ0rl7poS0osV5yntgi/xK+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3GDK6FnedYfw86mHvrr70Ilgqu2MSNytZNy7zBkCPQ=;
 b=gutyxScWtCfjRE2Iw432mVzts8g8/8513XC3ek2xG6OebeDXQhGPM4wuhOKlH7O4OEy+YBHVzQSxKMpuYwu8Ct0YaoYbJI1pvo+Kq/mv4Tx1BmHdMgxhm8AddG4rJNPSW1cMGZVkXFSEvnL/AqkFAZVEUoxRGt7bef97EA8xckA=
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com (2603:10a6:150:3f::12)
 by VI1PR08MB10298.eurprd08.prod.outlook.com (2603:10a6:800:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 16:34:33 +0000
Received: from GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182]) by GVXPR08MB8233.eurprd08.prod.outlook.com
 ([fe80::af81:850a:9bd0:1182%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 16:34:32 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH 00/15] KVM: arm64: First batch of vgic-v5 related fixes
Thread-Topic: [PATCH 00/15] KVM: arm64: First batch of vgic-v5 related fixes
Thread-Index: AQHcvTY08/fdUe4S+UKiF9kjcBRYwbXI3hOA
Date: Tue, 31 Mar 2026 16:34:32 +0000
Message-ID: <cdc69fba5df6777dd1ce51de5b535ee459653fad.camel@arm.com>
References: <20260326153530.3981879-1-maz@kernel.org>
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GVXPR08MB8233:EE_|VI1PR08MB10298:EE_|AM4PEPF00027A6B:EE_|GV2PR08MB11520:EE_
X-MS-Office365-Filtering-Correlation-Id: 822b7dc4-79c2-4b6c-0fce-08de8f43896e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 hwDSINgyw3IlfLPpUlPeQL3Kqh4vpm8Fkt+6AYxwZco3Dp9I/tT9t9oDVd81L5h3mH1+3N6TpXl/RQVszVWwoZ1AV9vrkABS1/rMqF2XcoTpuKcdFSCGWY5funaBuc6Eycsx4e1UBWREYJHgzKZpWmij5Y6HcL1aBn3BBCRSN4/AsjXX7K7A6kwZ6+OwaIJ3ZOCN+mBp2WXKJpfqoC8qiV4AnLLR9/7Xu1i1eXudzL/MCXzAjmgH+6vgyK4pxHDFewhEZL4v+xmJUfrucGNHoWxGOVZ/7g5xPPqvsbKgInSMq7yLdadm3VUZNLi6RLuuLatKb7KJ0MVQ9cH8BczJNpsBlnoXxtmf1pi7BjXwZwg8hqDsXI8mNIRMP0CrxuIbqkwgPfjIJkWkegv2eePCR9LWlK8J7IzVQlxndhyYbj94Db4NMSMDXRbYKu+CAsdcqrAq5uvg7gp/sk2b0M7oG87RvFqppdOPCZZEq1RauF6wU9TEinCAJSReJqc9aQRgSMa970VcZWAWFXuILtgSmzphW3Ag0RatitYNXXZ9tyf7YrdWg5J8F2Ma/w6p0pY9fT6EppIqsavR47akHlw79acUTdCd4wTp+yg3guwebw3pCJRymnovl+O7NJ+wu+tZGsuFwwSrnH9+dwMgaFVCl7RBitPxVeBkZYPs7+nqRzJ34lO/DpjeOEj2XgSb7ObPILalM6JCvQLdBmovLeVHUzL8Xlwg6GkzbNV29FLX9PI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB8233.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3F357C354B95942B2A99CC915A8CC9A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 W+YnjMXLsQW3SRXiqtZ90QiYgiLO9zAtfWAlizG9flYTZe56S8lw2adQWQuzRBVlOaYZ1kr97w0d4+jJnBSz0cMCxYtNqGXrbUuyCnJkIoVavgTP81Bdqe2atD1Yapyl6ad47DuwZUGTa+uALK5/gRomRFllpPLJ/B7CmVmCZ8f34VkN0uUyvLhG/BlwyOf0qHcDNmFo/75W6NtD+w6e7aHOtk2kHOdpiJx9WvD1CJhJrhHdP+/CzQacS2QvQwNT9Fy4QWV0gMmxR5QewUeEOpZu/zwvhJ7D7Y9S+cGBbHqTFKutPmEaGDkxRBxqmUlNhbVojZnmDlppptSO4bzUYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10298
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	21a10ae7-02d5-42c3-3458-08de8f436319
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|14060799003|36860700016|35042699022|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AJMb/myUDTvprYRG9z67s73XlU8mqctWZAKqryxBhS1FRAN23mmeU5L6DBLd40IH2uBgTE/HcFcoA0Vl/Nn9rQSxtZsUHwzh0ybPB4RwG6u1jIdAodvjoSMK+wFZ3xedXhMpAXoz4jKuC6ZQudh1DHaBrE+B/OTRIEE3oyidZ1HoySVRQFp78Ap+glWflcGZrORZ3jeIlLtFftMUx+AJ4iq5KAe3ruNwGIPpA644GtSWDFuut09Cp0eT9T+B6e2ANQvTdOq6s7NutLPq7Nm4/vJPkBF6QALRc5NDUo4Ekh5n+QeRQYfhYAF0prll+Mkqy8T/un4IoBzNca16B5n6DbRG55br8Zp68b54g0vUONUplDLrX9Iz5VL3bY1FAnyVEBbDYd84Rh2/4qI0CNr+hxruFj/uY3rWKVJxnLXjgGkGjMBnFZVESVxj9fJtUeNzxxyp+W10hmaghFiND5cZi5GO4WUQU02l6Tbuvyi3AmaPQoaMqi+NjCFq2bTokJ7UzT7hw7uUUVFctEQ0miOcRA4TCZrCeki82wXWMGmqiSkKCB1GtezZX9uiduf2IKx4DanqmG8jABn+lZSXwFz7KGZjDld+0IuQWzrSRTTXcKuCQ4Q24rAZ1BxRlmkodNYjB8pjXmxA5bultTrF1qNE3bZ9sbdRybdV1ZDyXldvse/+okA49xdXE3j9SiUmdmrXnPFRRt1Yd0Pc9GN4stOrYw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(14060799003)(36860700016)(35042699022)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8/T31Bmhvx1VBY7WnHvNFidAmt4ebUjO6aCRRyD/0oRFw9On8dBkn/g8eZUxNpBQCoS+BvFUVDqqiSAjEb99f6/JJGm9wgFLXL9n1VgPFmXXZ6holii8Bp/9MzDKZH2c4oIm6IFh9dBZu1W0vdldHfO/ux3aKhe+dJfaTP9D14LuVl+MdoVHFzuaYy7xlyKl9Q+ZcJ3YbKXkq5cS6lyGAvafO810SJ/AvXpkO6HsvpmPRWyhB6ON1yIw5Hiu3XoEI5V8pVetPKmRuVTSep9aZtoRyxwyAs7fgzGROKfMC3vG5Zw0rJLmMYHt1TEMwT/hTLgytjSGJ66oqYC1Sr3+qGFPmqgcFy/HHznev9qrJVBwYMUW6BHeDmhzhgcoeig3iugBGx7ht4YAsp26Ea7K0wsRAFfqZwIAOymPCNxwQm4OzCPgJnAkvZR7q2PX8Fmj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 16:35:36.3424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 822b7dc4-79c2-4b6c-0fce-08de8f43896e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11520

T24gVGh1LCAyMDI2LTAzLTI2IGF0IDE1OjM1ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IFdlbGwsIG1lcmdpbmcgdGhlIGZpcnN0IGJhdGNoIG9mIHZnaWMtdjUgcGF0Y2hlcyBkaWRuJ3Qg
Z28gc21vb3RobHkNCj4gYXQNCj4gYWxsLiBXZSBpbml0aWFsbHkgZm91bmQgYSBjb3VwbGUgb2Yg
cmVncmVzc2lvbnMsIGJ1dCBtb3N0IG9mIHRoZSBjcmFwDQo+IHdhcyBhY3R1YWxseSB1bmNvdmVy
ZWQgYnkgZXZlcnlvbmUncyBuZXcgYmVzdCBmcmllbmQgKGVuZW15PyksIHRoZSBBSQ0KPiBib3Qg
c2l0dGluZyBiZWhpbmQgc2FzaGlrby5kZXYgWzFdLg0KPiANCj4gV2hpbGUgbm90IGFsbCBvZiB0
aGUgcmVtYXJrcyB3ZXJlIHZhbGlkLCBhIGJ1bmNoIG9mIHRoZW0gd2VyZQ0KPiBhY3R1YWxseQ0K
PiBleHRyZW1lbHkgcGVydGluZW50LCBhbmQgcmVzdWx0ZWQgaW4gbWUgZnJhbnRpY2FsbHkgaGFj
a2luZyBhd2F5IGF0DQo+IHRoZSBzZXJpZXMuIEhvcGVmdWxseSB0aGUgYm90IGRvZXNuJ3QgZmlu
ZCBldmVuIG1vcmUgaXNzdWVzIGluIHRoZQ0KPiBmaXhlcy4gTm90ZSB0aGF0IHRoZSBmaXJzdCBw
YXRjaCBoYXMgYWxyZWFkeSBiZWVuIHBvc3RlZCBhbmQgbWVyZ2VkLA0KPiBhbmQgaXMgb25seSBo
ZXJlIGZvciByZWZlcmVuY2UuDQo+IA0KPiBOb3RlIHRoYXQgZ2l2ZW4gdGhlIGFtb3VudCBvZiBy
ZXdvcmssIEknbSByZWFsbHkgaW4gdHdvIG1pbmRzIGJldHdlZW4NCj4gYWRkaW5nIHRoZXNlIHBh
dGNoZXMgb24gdG9wLCBvciBwdWxsaW5nIHRoZSB3aG9sZSBzZXJpZXMgZm9yIGFub3RoZXINCj4g
Y3ljbGUuIEkgZ3Vlc3MgdGltZSB3aWxsIHRlbGwuDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9zYXNo
aWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwMzE5MTU0OTM3LjM2MTk1MjAtMS1zYXNjaGEuYmlzY2hv
ZmYlNDBhcm0uY29tDQoNCkhpIE1hcmMsDQoNClRoYW5rcyBzbyBtdWNoIGZvciB0YWtpbmcgdGhl
IHRpbWUgdG8gZ28gdGhyb3VnaCB0aGluZ3MsIGFuZCB0byBmaXggdXANCnRoZXNlIGlzc3Vlcy4g
QXBvbG9naWVzIGZvciBpbnRyb2R1Y2luZyB0aGVtIGluIHRoZSBmaXJzdCBwbGFjZSENCg0KSSds
bCBzcGVuZCBzb21lIHRpbWUgZ29pbmcgdGhyb3VnaCB0aGUgcmVzdCBvZiB0aGUgaXNzdWVzIGZs
YWdnZWQgYXQNClsxXSB0byBzZWUgd2hpY2ggb3RoZXJzIGFyZSB0cnVlIHBvc2l0aXZlcyBhbmQg
cHJvdmlkZSBmaXhlcyBmb3IgdGhlbS4NCg0KSSd2ZSBnb25lIHRocm91Z2ggdGhpcyBzZXJpZXMs
IGFuZCBhbSBoYXBweSB3aXRoIGV2ZXJ5dGhpbmcgZXhjZXB0IGZvcg0KJ0tWTTogYXJtNjQ6IHZn
aWMtdjU6IGFsaWduIHByaW9yaXR5IGNvbXBhcmlzb24gd2l0aCBvdGhlciBHSUNzJywgYXMNCkkn
dmUgbWVudGlvbmVkIGluIHRoZSB0aHJlYWQgdGhlcmUuIEluIHN1bW1hcnksIHRoZSBgKyAxYCBp
cyBuZWVkZWQgZHVlDQp0byBHSUN2NSdzIHByaW9yaXR5IG1hc2tpbmcgd29ya2luZyBhIGxpdHRs
ZSBkaWZmZXJlbnQgdG8gdGhhdCBvZg0KR0lDdlsyM10uDQoNCldoZW4gaXQgY29tZXMgdG8gJ0tW
TTogYXJtNjQ6IFJlbW92ZSBldmFsdWF0aW9uIG9mIHRpbWVyIHN0YXRlIGluICAgDQprdm1fY3B1
X2hhc19wZW5kaW5nX3RpbWVyKCknLCBJIGFncmVlIHdpdGggdGhlIGNoYW5nZSAtIGRvaW5nIHRo
ZSBjaGVjaw0KaW4gdGhhdCBsb2NhdGlvbiB3YXMgZGVmaW5pdGVseSB3cm9uZy4gSG93ZXZlciwg
YSBzaW1pbGFyIGNoZWNrIGlzDQpyZXF1aXJlZCBvbiBHSUN2NSBkdWUgdG8gdGhlIERWSSBtZWNo
YW5pc20gYmVpbmcgdXNlZCBvbiBHSUN2NS4gSSd2ZQ0KcHJvdmlkZWQgYSBwb3RlbnRpYWwgKHRl
c3RlZCkgZml4IGluIHRoZSB0aHJlYWQgdGhlcmUuDQoNCkZvciBhbGwgb2YgdGhlc2UsIHdpdGgg
dGhlIGV4Y2VwdGlvbiBvZiAjOSAoJ0tWTTogYXJtNjQ6IHZnaWMtdjU6IGFsaWduDQpwcmlvcml0
eSBjb21wYXJpc29uIHdpdGggb3RoZXIgR0lDcycpLCBJJ20gaGFwcHkgZm9yIHlvdSB0byBjb25z
aWRlcg0KdGhlbSBhczoNCg0KUmV2aWV3ZWQtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJp
c2Nob2ZmQGFybS5jb20+DQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiBNYXJjIFp5bmdpZXIg
KDE1KToNCj4gwqAgS1ZNOiBhcm02NDogdmdpYzogRG9uJ3QgcmVzZXQgY3B1aWYvcmVkaXN0IGFk
ZHJlc3NlcyBhdCBmaW5hbGl6ZQ0KPiB0aW1lDQo+IMKgIEtWTTogYXJtNjQ6IERvbid0IHNraXAg
cGVyLXZjcHUgTlYgaW5pdGlhbGlzYXRpb24NCj4gwqAgYXJtNjQ6IEZpeCBmaWVsZCByZWZlcmVu
Y2VzIGZvciBJQ0hfUFBJX0RWSVJbMDFdX0VMMg0KPiDCoCBLVk06IGFybTY0OiBGaXggd3JpdGVh
YmxlIG1hc2sgZm9yIElEX0FBNjRQRlIyX0VMMQ0KPiDCoCBLVk06IGFybTY0OiBBY2NvdW50IGZv
ciBSRVN4IGJpdHMgaW4gX19jb21wdXRlX2ZndCgpDQo+IMKgIEtWTTogYXJtNjQ6IHZnaWMtdjU6
IEhvbGQgY29uZmlnX2xvY2sgd2hpbGUgZmluYWxpemluZyBHSUN2NSBQUElzDQo+IMKgIEtWTTog
YXJtNjQ6IHZnaWMtdjU6IFRyYW5zZmVyIGVkZ2UgcGVuZGluZyBzdGF0ZSB0bw0KPiBJQ0hfUFBJ
X1BFTkRSeF9FTDINCj4gwqAgS1ZNOiBhcm02NDogdmdpYy12NTogQ2FzdCB2Z2ljX2FwciB0byB1
MzIgdG8gYXZvaWQgdW5kZWZpbmVkDQo+IMKgwqDCoCBiZWhhdmlvdXJzDQo+IMKgIEtWTTogYXJt
NjQ6IHZnaWMtdjU6IGFsaWduIHByaW9yaXR5IGNvbXBhcmlzb24gd2l0aCBvdGhlciBHSUNzDQo+
IMKgIEtWTTogYXJtNjQ6IHZnaWMtdjU6IENvcnJlY3RseSBzZXQgZGlzdC0+cmVhZHkgb25jZSBp
bml0aWFsaXNlZA0KPiDCoCBLVk06IGFybTY0OiBLaWxsIGFyY2hfdGltZXJfY29udGV4dDo6ZGly
ZWN0IGZpZWxkDQo+IMKgIEtWTTogYXJtNjQ6IFJlbW92ZSBldmFsdWF0aW9uIG9mIHRpbWVyIHN0
YXRlIGluDQo+IMKgwqDCoCBrdm1fY3B1X2hhc19wZW5kaW5nX3RpbWVyKCkNCj4gwqAgS1ZNOiBh
cm02NDogTW92ZSBHSUN2NSB0aW1lciBQUEkgdmFsaWRhdGlvbiBpbnRvDQo+IMKgwqDCoCB0aW1l
cl9pcnFzX2FyZV92YWxpZCgpDQo+IMKgIEtWTTogYXJtNjQ6IENvcnJlY3RseSBwbHVtYiBJRF9B
QTY0UEZSMl9FTDEgaW50byBwa3ZtIGlkcmVnDQo+IGhhbmRsaW5nDQo+IMKgIEtWTTogYXJtNjQ6
IERvbid0IGFkdmVydGlzZXMgR0lDdjMgaW4gSURfUEZSMV9FTDEgaWYgQUFyY2gzMiBpc24ndA0K
PiDCoMKgwqAgc3VwcG9ydGVkDQo+IA0KPiDCoGFyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuY8Kg
wqDCoMKgwqDCoMKgIHwgMzIgKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiAtLQ0KPiDC
oGFyY2gvYXJtNjQva3ZtL2NvbmZpZy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArKy0t
DQo+IMKgYXJjaC9hcm02NC9rdm0vaHlwL252aGUvc3lzX3JlZ3MuYyB8wqAgMiArLQ0KPiDCoGFy
Y2gvYXJtNjQva3ZtL3N5c19yZWdzLmPCoMKgwqDCoMKgwqDCoMKgwqAgfCAyMCArKysrKysrKyst
LS0tLS0tLS0tDQo+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuY8KgwqDCoCB8IDMy
ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCj4gLS0NCj4gwqBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjUuY8KgwqDCoMKgwqAgfCAyNCArKysrKysrKysrKysrKysrKy0tLS0tDQo+IMKg
YXJjaC9hcm02NC90b29scy9zeXNyZWfCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0N
Cj4gwqBpbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5owqDCoMKgwqDCoMKgIHzCoCAzIC0tLQ0K
PiDCoDggZmlsZXMgY2hhbmdlZCwgNzAgaW5zZXJ0aW9ucygrKSwgNTEgZGVsZXRpb25zKC0pDQo+
IA0KDQo=
