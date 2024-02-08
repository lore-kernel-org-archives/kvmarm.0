Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E292F6D1C5
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397636; cv=fail; b=AvAkDrMQO4V4TffSwMupfRfTqM4C5ky8WpX84IkM+e3hI01btBCM9AVVTt/0fKaGY7eEK4f2WV1CCGHNIZGH9Touu7S+haJUgGXWlQfxKVOBwpQ31lLe/cZ7zzcuIdBueqBWhLUST6TmxOcnG7tDK4tw5Yfng2ttSsvSN+qFIOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397636; c=relaxed/simple;
	bh=EZqhmUIvApkwwytpBA5dY1qZbCnCo9avgNYCxUp++xE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tAK6GOEFi6S2y92w9IPRZDPWdS36PFrQjZDZWR/ErkOvOr2HX3gzCHh3I3uRAPwgu7Bt56KTz9bmCEa9JhmgNDg5FYLvf6kWoV5l+SgBu/FGMhlA5uJ7KB1kYsm9rvWAB7IJ23WaWUXlmtvwjxwQcuIZgfJ1F6IJP/qis0oar0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aEFzKLvy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T4HFMOYG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aEFzKLvy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T4HFMOYG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4188xkNb009442;
	Thu, 8 Feb 2024 13:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EZqhmUIvApkwwytpBA5dY1qZbCnCo9avgNYCxUp++xE=;
 b=aEFzKLvyi7BNPxL5dqH92/S9n/BaL8jpz10n7rVtVk5I0tkGQ2bpB/kAZkD71QAlAbNh
 21BuICrNkFqZxkHQo0QTp9bzJll8jLq7Bme8aIZtSGy+TrLH9HHEgooQxZ6aA1m5y70q
 BjjXuWiXcQfh3+LDHQTKde6YVAkiEoCREbyyeNIecSOxQ43nIeTcTgOSrxowpLHK49pO
 Ie2U10sUIodCUN93Ycpo557vtnT4ENeQRAL3pPI58xtWp/zcdYW5TAOhbuaKWSaOHIJr
 gGSYvYIMD0NI9bUfTG7nl254SK4mVXxD9fhMthgopseHO+qPMBBuv8fHO7C/MWwnVs9a SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1vcfpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 13:06:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418BKEWt038387;
	Thu, 8 Feb 2024 13:06:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxadhdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 13:06:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQgSA8083uoqPZOa7X3M5YuxhW5X62I+I48cmQceI58Tbmwlje9v1FRJ9FzCN0MjUZ4TKuPeBW6ue+vkQlCbhHBs0+ZKpwqIF09GZinWA++mMYw91EPgnAEK1bmFPBZCaFyOHQSBqZ8pVjl8DvNOWb2cLYKdyIaX+Ch5GjGIEwNsFayH9eWnnfFEdP919TpJ1v5MEsxiXt52hXDBpMSGeAflaDcdpr3Wa84xXWXnPJF4LClpZWvrAmAkRTQvAN+O6d/mIs7IE8pp2LmDweDiHmIqE/jQvYOJsvuru3/s6WGPwsE+FiNC+vA16nMVYTcz6/sRSQXOePL2mxkGCfev3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZqhmUIvApkwwytpBA5dY1qZbCnCo9avgNYCxUp++xE=;
 b=YJpD03y6S8lqbHcoThC2XTtETsqHlIzWv2raVrOIBgwhEPu4oJqGCJlt047Cp9TBOiIyHXj0nwhxiWIYCjtuzFDXftQtkT4wwW/AYUQxOqRmfPo1IzUrn06ADwHxZfAHTF14BBbfN3Moz9G7IVHrjjPOS7CIjMw2IELUu+e2qK3utoTF1ruzY2OyOl/Y9JWkie57blOE7i+OhUhyyTG38pAEgjvqFf40V3Yn3qNqL/RxKrw4Cu+CmPUA5+iELT4hipNrVwoLm1m5rGYHPImWjf91/9PQS1SWN8Rt199o4dPXgmng7ZC6t5hjJCkHdHIwyZWb3Ohvnm8h9kdfkfO4Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZqhmUIvApkwwytpBA5dY1qZbCnCo9avgNYCxUp++xE=;
 b=T4HFMOYGyhh5j4WoydDQe3aDGUuuDVyz4CuONf34ilARnpGZf5D3hJQW5gdeikK6menakgrlE4/88aEWqv3vMyso/eCta987xHyjMQmca4NF0OBCcaR3IEZ2fiNpDBvAICglNp/VS+KJ8DfZt1OAWDIUvsb+oG4DM8Oj3FLGFi8=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CH3PR10MB7161.namprd10.prod.outlook.com (2603:10b6:610:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 13:06:52 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33%4]) with mapi id 15.20.7249.039; Thu, 8 Feb 2024
 13:06:52 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Marc Zyngier <maz@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Suzuki K
 Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>, James
 Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui
 Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 04/10] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Thread-Topic: [PATCH v4 04/10] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Thread-Index: AQHaTV7sgytD+xvOF0eU8Mnea9aImLEAhJKA
Date: Thu, 8 Feb 2024 13:06:52 +0000
Message-ID: <FFB5BF90-BD6C-489B-BDBF-78FC6D529262@oracle.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-5-maz@kernel.org>
In-Reply-To: <20240122181344.258974-5-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CH3PR10MB7161:EE_
x-ms-office365-filtering-correlation-id: d0709a7f-6e3a-4cc9-f9a3-08dc28a6d1bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Imue//CnTtvRljhFnl/xdyDTSbbPhclvQ+CWSJNpSRQajj5u1QE4/62A4iXC/KFfW5j/LbXqGGUcN8SNmwxbjqMrk84ssDpZxrbjNdhUBMGi2MME7KehO07nFzp7bOBlqBAntiTSUz6auDOX9bXyxAIG6dYj2JuNrVt/AXAzF2Frg0SW7YcGuIlPKsVGvJ1wlDX0bKi5eWcW/rZqpuFHXAilMtxAGhf6nTVzqJ7C79M7zQ8/oawYctJzD1MK+GhrTbLc8XEL1dM0EebL5YfZeDRIgnuWogwtLPCKptiw5N5Hvfig7pGyp4FclO/FP/U16fJP+8K33ILHPwaGhkPu80Uh8qJHDsKpMtwvn7gcbqFopbEROl9qXtRryjcaxQk3GSRSQ5J+PFjpYELSe0tx3jhVcPXxvcumczldsPh6hxj6mWI5jzoHsCLWJ4T4Vd9tJ1zJx/a56V3bpYriq64+ZBthSLXlLO0ytkWj9PuOdr9UBMN+rkVyGFt1XDvSN1/bihLHywmJCMUzmDfk3K5cbONCBh6LVovyMR5MT35tcOP4NgEzJl4tIPACdATBetPYN7Itg4J+d0VAdfgqq3H98LI/dOE/hNm1URsH0mCsKqo=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(366004)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(41300700001)(2906002)(66476007)(6512007)(38100700002)(122000001)(6506007)(966005)(478600001)(6486002)(64756008)(76116006)(316002)(66946007)(66556008)(6916009)(54906003)(66446008)(26005)(44832011)(8936002)(19627235002)(8676002)(2616005)(53546011)(71200400001)(4326008)(5660300002)(36756003)(86362001)(33656002)(7416002)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?M0RNQzRHSkV5WkZHV0ZrSG5CK0FKSlF0Zi9ucldaSUUzdnloOVJHUm4wZVBM?=
 =?utf-8?B?S1B3WEFFWGFpck13NDAzamVXWWNSRCtwek1hM1lDNHhRQi9Ca3ZFNFhTeW0y?=
 =?utf-8?B?MGRrMS9KWm1OVXBHajFheHBDRGxrVzVyU0ozclBMeFcyS2xxYlh6L3ZaRFB3?=
 =?utf-8?B?U0NyaTdIVVhmMmhheXN2SkpxQ0NIQmtmcG9LR0xzZVNlMG1SaFluSCthcUR0?=
 =?utf-8?B?eTVyM0VJSG93akdYbjUvQlhsSXZrOTVyMFovL0QzaEtQNk1keDNkY0l5L29q?=
 =?utf-8?B?MDhrQXRZN1l4R1M4NjVmUkdtM1BYZW9IQ1hUcU0vV01uRytzUDlKYmd2TTdI?=
 =?utf-8?B?ZWxiSmpTSGUyL2tIS0gxM0xDUUxqQXZncnJpbHVSMkhIOCt0NmtUckJwZStp?=
 =?utf-8?B?TXgxUFRxanlQRHJXUnNGREJnd0tLK0ZkbWFUUjNiSnV5TS9LazlhVXJFdVE0?=
 =?utf-8?B?MDFsTmhtclpiV0dLa080anNzSEptL3U4SFZ1UUhGR2JCTGxjQVNLK1RaVWNW?=
 =?utf-8?B?T3F0WW5PUi9iVkNhMGdRSklSb3IwY1Z1engzRUozOXBxLzJTMTJOTFpiN2Js?=
 =?utf-8?B?blluUTQ4c1lBMHNoZU9Kb2ZlY1FqT29YSGVienhzc3dienZyOUFNUi9DL2Vm?=
 =?utf-8?B?QS9zVElmSExYK2RjdEppR3IvSjdVaWlFZ0ZDdG5WOEtReUNTS1pnL3pYSXlQ?=
 =?utf-8?B?cHl1dmtIVlhaSStaa1B6TUIwK0hDNW1MVjR5Vk5sQjMwbXVybnlHQ0FuVUdq?=
 =?utf-8?B?Nkh5YUMvaFhDK3EyS0wxYWpMT3liLzlkOGtwSnY1TFZlYk5BVC90MTdoaEY2?=
 =?utf-8?B?MlVxNERsWHVxb0k0NVFSdTZkbjRQNlc0S1J0ckxTZ3pQNEhzSEtmVUkydnJE?=
 =?utf-8?B?NTVXaVdiOUo3dWVrM1JWYlplNTk0ODJZS3EyMkdWL3ZMNEtneldXM3lPanlM?=
 =?utf-8?B?Tm5NMVVGK04reGFyZXh2ZEVvZFFnM0xOc3d2eTlqS0NodkFNdHc2TjV1cmww?=
 =?utf-8?B?dDdkWmMvWERPcjZhbFFUTDlvRlpKUUlETmNLaTdhVHZ1WVdYRnJSRzY3UnUz?=
 =?utf-8?B?QnNzczNYL0ZIWEVOSE9DTlQ2THh4Q0dFaGdYckk1YU8zU0FTRzRXbm9aM2Jn?=
 =?utf-8?B?SjdIRklKd1owZ1VIUjk1Zkt4UHpNRjNqbmFOY0Q5Rm5rbGxGeTd3Z01SR0hw?=
 =?utf-8?B?Z2lyczF5by8zUzBWbzgwVUFlaHNad2tpcyswcmVsV09ISkpPTjNzVG16NGpz?=
 =?utf-8?B?Tk1Uck5hbFhHYzdULzFPRENVVnVTUzhEcFNwV2xiUjVLUGdSS1AzUEV1MTBQ?=
 =?utf-8?B?WTJUK1FnWjFnWjQwY2xGam4veG1JRGc0REF0RFhrb1hQNzRBeTJYT2NJb2tq?=
 =?utf-8?B?bDNYdTlUV0FUOE90MU9tWE5lYkFMMFhZZ0RjcU5WVUVCcGdET1A2cGdjcEhO?=
 =?utf-8?B?eVZBU0JCMDRhdjFhOXUyMDlWWVU2VWJQRWlHblk5V0sxOHFGK0FjTXlaSW11?=
 =?utf-8?B?QkJFUFhCQ0g3SjRDdldqUnJtM1Y5YUF3TWJOT0Q4bDV0dmdNRjRFckhQU2lH?=
 =?utf-8?B?TnFqWTIzengzV0FwMUJjdGZmcXE0alFvQlZ2NTFvaXJlemVWeHlMOHhyTFA5?=
 =?utf-8?B?VWNjRGJETWhGTGVMcno3UmVZY0pGS3pFdFlab203eHNLSUhLNE5mcjRxVm1u?=
 =?utf-8?B?SnFsQnV4RUFoVkx4OEMyalNBZTZIRTZZOFhBQkt2TUhWSEgzamdVRExKSDcx?=
 =?utf-8?B?YVhobzVIR0ZsbFJ5dmxrZStEckNiTndvSGpXdjFHdHVTVDZrMXEvYWpoa2xz?=
 =?utf-8?B?UkZaTVNPeGI4Z3JRd0pxQWs5RWRXUWZTNTVGMHFuYnBpSjZiSSt4OHAwY2h2?=
 =?utf-8?B?L3RzcFQ4WC8wWittREZtcHNjNzJRekQwc0JNb1EyYVk3YVZvL3B3Mm8yeER2?=
 =?utf-8?B?aTl1MythK3Y5QVdHK2cxa3RWN0ttQnBmNyt3SmRlTEFldmc2NEt0ZndoQ2My?=
 =?utf-8?B?RGVTa2gvdmFkaWpwUXg2N0FmK2N0eWtNcnpMMFRPMFdUalZTVDdvWUlXcVlI?=
 =?utf-8?B?ZEllM09WM01CNDlBUFlxa245RHpNWTRDTjVpKzR5cXhKMVRxTFZLTU1LcTFt?=
 =?utf-8?B?b1Y2cjlpcE1iQ241RklYb3RyY1RqdG5HcVBqbCs3RHpCbUhwRVNsU1dBMSt0?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72C96BCC46C1B94286C7D710772D8ABB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yxSpBKcyLF/Mvv13b8npwfVt7wryrsNlu6d+vTXIM93XAOaS+95yE9CQzZArrRrpEQbc58ELgsDWYvazycSKagMclcmbIfq1fJNIVrJ0LBbCPHk+YTfy+UmNSXLrEMcaBqAEyfXl3g1RO1LW6kQKl3pr5qBWJGvMDHND/jrNaCu4Eu5oalWSL/vZewpm+kqMHuDXHBrCxCekFE3b75823nLaGL7Ds8iQRDoGlBf4YIps0dRbOE+clKcXQf2TdCqdWZgByRNceAJiUv0/9FhJrt8Fh6mQ+HtZwrxHd5EqfREhyD0QHVZXo4S30Zj0ZSljrX0xfgrAfu8T7dtDBNQW5Nv7ZdcjULoz/pW0ikK7e70aGh8DvTnLqOsR66KrvrhU6Czsu7qc4OC3As+n93Wd1USCdj8A0zZw5X2aqOhVVrnTNGRb3lXPXO9nI4i4ThKNhhvivxTJFEhk/kgTClLvIA4VLi/vxV4rswHRSAkHH0b1FpuUM26wnD9NQsLNxFm5Nx5gJ8eOlPsI7XmWlrcaM2zpCe9EbFhbHtMN9J03OBDC5l/olZy4LBhgAqVf2KgkmGWRqwbSsZykCziFl7afWjVafcwQmcnnoVTucamC1PM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0709a7f-6e3a-4cc9-f9a3-08dc28a6d1bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 13:06:52.8444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: quqHxQ5dv/x5uQSBGipjpw0OfSW8xcm6dD4rq+9CUxPhxgOeirTC9N7/jVJuXhASB9/2DA97zdK/CugGncYuAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_04,2024-02-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080069
X-Proofpoint-GUID: 2xSKwinV5UiS7yjJcvprDwWJaBNV7oBZ
X-Proofpoint-ORIG-GUID: 2xSKwinV5UiS7yjJcvprDwWJaBNV7oBZ

SGkgTWFyYywNCg0KPiBPbiAyMiBKYW4gMjAyNCwgYXQgMTc6MTMsIE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gQVJNdjkuNSBoYXMgaW5mcm9kdWNlZCBJRF9BQTY0
TU1GUjRfRUwxIHdpdGggYSBidW5jaCBvZiBuZXcgZmVhdHVyZXMuDQo+IEFkZCB0aGUgY29ycmVz
cG9uZGluZyBsYXlvdXQuDQo+IA0KPiBUaGlzIGlzIGV4dHJhY3RlZCBmcm9tIHRoZSBwdWJsaWMg
QVJNIFN5c1JlZ194bWxfQV9wcm9maWxlLTIwMjMtMDkNCj4gZGVsaXZlcnksIHRpbWVzdGFtcGVk
IGQ1NWY1YWY4ZTA5MDUyYWJlOTJhMDJhZGY4MjBkZWVhMmVhZWQ3MTcuDQo+IA0KPiBSZXZpZXdl
ZC1ieTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gLS0tDQo+IGFyY2gvYXJt
NjQvdG9vbHMvc3lzcmVnIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiAxIGZpbGUgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQvdG9vbHMvc3lzcmVnIGIvYXJjaC9hcm02NC90b29scy9zeXNyZWcNCj4gaW5k
ZXggNGM5YjY3OTM0MzY3Li5mYTNmZTA4NTY4ODAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQv
dG9vbHMvc3lzcmVnDQo+ICsrKyBiL2FyY2gvYXJtNjQvdG9vbHMvc3lzcmVnDQo+IEBAIC0xNzkx
LDYgKzE3OTEsNDMgQEAgVW5zaWduZWRFbnVtIDM6MCBUQ1JYDQo+IEVuZEVudW0NCj4gRW5kU3lz
cmVnDQo+IA0KPiArU3lzcmVnIElEX0FBNjRNTUZSNF9FTDEgMyAwIDAgNyA0DQo+ICtSZXMwIDYz
OjQwDQo+ICtVbnNpZ25lZEVudW0gMzk6MzYgRTNEU0UNCj4gKyAwYjAwMDAgTkkNCj4gKyAwYjAw
MDEgSU1QDQo+ICtFbmRFbnVtDQo+ICtSZXMwIDM1OjI4DQo+ICtTaWduZWRFbnVtIDI3OjI0IEUy
SDANCj4gKyAwYjAwMDAgSU1QDQo+ICsgMGIxMTEwIE5JX05WMQ0KPiArIDBiMTExMSBOSQ0KPiAr
RW5kRW51bQ0KPiArVW5zaWduZWRFbnVtIDIzOjIwIE5WX2ZyYWMNCj4gKyAwYjAwMDAgTlZfTlYy
DQo+ICsgMGIwMDAxIE5WMl9PTkxZDQo+ICtFbmRFbnVtDQo+ICtVbnNpZ25lZEVudW0gMTk6MTYg
RkdXVEUzDQo+ICsgMGIwMDAwIE5JDQo+ICsgMGIwMDAxIElNUA0KPiArRW5kRW51bQ0KPiArVW5z
aWduZWRFbnVtIDE1OjEyIEhBQ0RCUw0KPiArIDBiMDAwMCBOSQ0KPiArIDBiMDAwMSBJTVANCj4g
K0VuZEVudW0NCj4gK1Vuc2lnbmVkRW51bSAxMTo4IEFTSUQyDQo+ICsgMGIwMDAwIE5JDQo+ICsg
MGIwMDAxIElNUA0KPiArRW5kRW51bQ0KPiArU2lnbmVkRW51bSA3OjQgRUlFU0INCj4gKyAwYjAw
MDAgTkkNCj4gKyAwYjAwMDEgVG9FTDMNCj4gKyAwYjAwMTAgVG9FTHgNCj4gKyAwYjExMTEgQU5Z
DQo+ICtFbmRFbnVtDQo+ICtSZXMwIDM6MA0KPiArRW5kU3lzcmVnDQo+ICsNCg0KUmV2aWV3ZWQt
Ynk6IE1pZ3VlbCBMdWlzIDxtaWd1ZWwubHVpc0BvcmFjbGUuY29tPg0KDQpXb3VsZCB5b3UgcGxl
YXNlIGhlbHAgbWUgdW5kZXJzdGFuZCBob3cgdGhlIGtlcm5lbCB3b3VsZCBjb3BlIHdpdGggRTJI
MOKAmXMNCjBiMDAwMCAgdmFsdWUgb24gc3lzdGVtcyBwcmlvciB0byBBUk12OS41IHdoZXJlIGEg
cmVhZCB0bw0KSURfQUE2NE1NRlI0X0VMMSB3b3VsZCBiZSBSRVMwID8NCg0KVGhhbmtzDQoNCk1p
Z3VlbA0KDQo+IFN5c3JlZyBTQ1RMUl9FTDEgMyAwIDEgMCAwDQo+IEZpZWxkIDYzIFRJRENQDQo+
IEZpZWxkIDYyIFNQSU5UTUFTSw0KPiAtLSANCj4gMi4zOS4yDQo+IA0KPiANCj4gX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gbGludXgtYXJtLWtlcm5l
bCBtYWlsaW5nIGxpc3QNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnDQo+
IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtl
cm5lbA0KDQo=
