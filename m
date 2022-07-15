Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA6FC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 11:34:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF7B4BE25;
	Fri, 15 Jul 2022 07:34:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@synopsys.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@synopsys.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@synopsys.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BARugD-VNpUk; Fri, 15 Jul 2022 07:34:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB264BE2D;
	Fri, 15 Jul 2022 07:34:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF4BB4BA4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 04:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u7w0DUxFFi7R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 04:53:26 -0400 (EDT)
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com
 [148.163.156.19])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC2A34BC1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 04:53:25 -0400 (EDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
 by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F82Ehk006000
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 01:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 h=from : to : subject
 : date : message-id : content-type : mime-version; s=pfptdkimsnps;
 bh=Sug4vfdJ1NP+GDvursHyrLq59UbDkEZDPpqLXhfe8jg=;
 b=R/Cj2tfUYPuewAbzOVd9kT+QmwSw5xILDMhugAbVChfRTKPhU3AFskrZKIRjDKZi4QE+
 o/Xx8X/9Bzek8ybjLZp9/ZGW/Q8rd3egBounhISX4tDTUTmsnfMx1kiFsU8EUjD/xvV6
 qBguTFS3H5YFQKEowZkwTOWLsDdv13BcbIfgyj3NvwqVhDobsYFsh4lYKeIYbDu1tZW4
 P2hEqmJEIQX0pZcQ5ZZ1jl63fd1Ch+HcLjuXdO6GanfagdkotShtn8+/JH1Zgv10t4sw
 kMkF4LfwGbhMkfkWFbZ8SFnXyOyPSFqU9lAiVQYoyvdAZNstxBleJialMxU6qbSBsDbD lQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com
 [149.117.73.133])
 by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3h78pnew9a-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 01:53:24 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com
 [10.205.2.131])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
 by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 637CD40097
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 08:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
 t=1657875204; bh=Sug4vfdJ1NP+GDvursHyrLq59UbDkEZDPpqLXhfe8jg=;
 h=From:To:Subject:Date:From;
 b=AVkqizZMml8F7g/vmZHmoHlyrATUk6jvEV6xzqWeUjuBU1z0DC126C/v99n4z9szV
 owkjezLDZ4CoYuM/PrqSFmmE+W28CPDlSHmGiq1HgiXy1tCxZuYu1KvvMliaovKzL1
 CIETUArKUH0obt5Acf+W4jdnOWLroToUEVR7BhlZaPlswSDZMhv1nN17TWMwGqXX6M
 nh8MspmFGd0iAsnkkaDlGJnqYvw8E7sLotc4I1fIOnA3ZWMTRp1k2UH9vYrAI7tamq
 xF019tOQi1RoJB2cgD10G+hYjPQ0dGSiDxNVgzIfOeuugURcUloFn103SGlphzPloR
 /iP/EvQQo+fDA==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com
 [10.202.1.137])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client CN "o365relay-in.synopsys.com",
 Issuer "Entrust Certification Authority - L1K" (verified OK))
 by mailhost.synopsys.com (Postfix) with ESMTPS id 28A5AA0076
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 08:53:23 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (Client CN "mail.protection.outlook.com",
 Issuer "DigiCert Cloud Services CA-1" (verified OK))
 by o365relay-in.synopsys.com (Postfix) with ESMTPS id BB918400A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 08:53:23 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com;
 dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
 spf=pass smtp.mailfrom=tobies@synopsys.com
Authentication-Results: o365relay-in.synopsys.com; dkim=pass (1024-bit key;
 unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="oOwXA2YX";
 dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvs/oN2WfffE6BJX7kLP9UIB2KPoU50caxw5/fZGyGCYlGQRTOtGHlPEcts7XIEadHtC3+I5pIaIdvGkFpwjNL0/dZeDYgE6sj1ZpafobJjl9nbpppoP9Of0mRJO1joJ6tkItPwtTlwho6cBTB065gWJXNIS3FfeXCIGm5RcOfVC/g5ie91gKFZuk9Z4lKoHLDC5hN8wZVyj+/jj5LFV3wkQo3e4/JZqPszSinyP0OIOW0d0hxJs4n7h64gyRdmvIErkXeVc0pv6DqSzyE9xglLJFQvJJrdbGWEiW+VPic64wb1XbCloXr57kOJ9yzeCeGeUQBK0yDczr+md0Uf7tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sug4vfdJ1NP+GDvursHyrLq59UbDkEZDPpqLXhfe8jg=;
 b=abay27cA9JAZAfOaKOmwN2BgVcy17ooiD8EZSSUITYtR14vidlS5D9bDIfp3j4sPJU6wN5fe2YNhktCVUx+ESAGHLy7l0b55WzTpKcA1ckLsr4fpPIHe/kJ3YyHiPkf6+0EPxl+WBaF6hc6cJlNSdOIgXN90neUKq8fN0qQ0cnLfuO0KHp0gL+mnCBo6/Ni/ifXjJiAXGNNGlT56UsPra8GFNDue3+E21UPfGU5s7tQUU2jKAeGqbnll8pmVwKpMIXrVd9hwyNeLbYzKU4TOZUB2xKbK7MLrlYNH1/yvpRi90x+JmB9uMtDXuhxKf94PZtBLHHSrM7C8/5oZJ39GnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sug4vfdJ1NP+GDvursHyrLq59UbDkEZDPpqLXhfe8jg=;
 b=oOwXA2YXgaWbrpR6BH1XNWTxrn25h6w5fxLTEWsd2JfZxaUDolxAe9Rv7uePpk1mjlxVMyQ9+2lYf4mWl4eab9zB6T1ygfFComlfYmUL8t5sIGUXb8zbc2m9YEZtwsmFTMIz/sKUH+d5GawkZi1rpRhLLscsKJcPZ9poxXUcbLo=
Received: from DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17)
 by SN1PR12MB2398.namprd12.prod.outlook.com (2603:10b6:802:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 08:53:20 +0000
Received: from DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::71d2:76ea:f7c5:86e1]) by DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::71d2:76ea:f7c5:86e1%7]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 08:53:19 +0000
X-SNPS-Relay: synopsys.com
From: Stephan Tobies <Stephan.Tobies@synopsys.com>
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: How to re-inject a debug exception correctly?
Thread-Topic: How to re-inject a debug exception correctly?
Thread-Index: AdiYKDiRggBS9quZSsiBV9y0K42kNg==
Date: Fri, 15 Jul 2022 08:53:19 +0000
Message-ID: <DM4PR12MB5264D795F72137498EF87971B18B9@DM4PR12MB5264.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5Lmh0bWwiIHA9ImM6XHVzZXJzXHRvYmllc1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTkxODIzNTJkLTA0MWItMTFlZC05ZTllLWFjNzRiMTcyYTQzOFxhbWUtdGVzdFw5MTgyMzUyZi0wNDFiLTExZWQtOWU5ZS1hYzc0YjE3MmE0Mzhib2R5Lmh0bWwiIHN6PSIzNDE1IiB0PSIxMzMwMjM0ODc5ODAyOTI5MjAiIGg9IkRPZWlrZlBBVXh1SE55RWlsaUtwQ2NpTHc2ND0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 026d3111-c38d-476f-8d07-08da663f7769
x-ms-traffictypediagnostic: SN1PR12MB2398:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vzQcpUOXZ7FrUdQ0y7EbV1b4WnhIWFTQJrcPkrUKUHFjwy+jJIze5ldB3CSniVBY0eBAE5Q52RESZuqUoXBmit75KI4lh1dpiONfzUsXaKrMFs5WCRhz+cLeMJOistUYaQSLEpcLeMFqvpFn5xBYjESu+zI/z2YgI1BPnnc+58DxOqbiSicUMPsCfKpJb4nLk2DpXCOwSPmtpUhuXm2E7g1CnIGtxQGUMf39NBbMGt20GoNSWF8Sh0dhrY5xxTsK1NqQN3uGzdnn1S00uPGUu1JTzwjI7kemJOt0iWd58fYHFNRBe+OpLEgCMPyOJcAjtxT1ML+fN/b5jsn+Jx4zdu1M/AUgfpadkHzM2n+w7GQRl3tEyEKVCpDhfSszbtjnx//3zvKHO1VLKp6ux/GDoE0uTfclQNTS5jZng+xO+mvsaEmdruNfdTBL0Nn3y1dG3a0NQpNWNo/uXeUf6LmsZxkOvGCAAxMeIzbRrDbOUJgRmItcH2LP1FbVfldtx6V63yTDy0kUziwqhnBu8WxoOKeY2kLNhiSNzB2O6xsvigAgTIwu8CYbz0bGNZ2aogjZ7It6iRZ1O6MkdUfiGlKah6hZ+hh6yhQ/hL9dqStpfIOjy6Lhywoe2pfd7tN3pCjriS2F20Wd/Lv/OCl1bBZPypJWgxumNqHZ4WPouj4YyG00j/vO2oJkbzATKfBdDMKcWrfo6Fz7mKfepzYj+gr74LbuVRCS2J7Ofnwn/VN3HWq7+BM+76BuCywWHqwvE73kf1ZFTDCKJuPuR120K/WjvFbxf+mzK3olmXIVA9E0KAipUkEqYHRAfaP3g4YSjtwe
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM4PR12MB5264.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(136003)(346002)(366004)(376002)(39860400002)(4744005)(2906002)(5660300002)(316002)(66946007)(76116006)(66446008)(66476007)(64756008)(8676002)(66556008)(55016003)(9686003)(71200400001)(6916009)(26005)(41300700001)(7696005)(478600001)(8936002)(186003)(6506007)(66574015)(33656002)(38100700002)(38070700005)(86362001)(52536014)(122000001);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckdFMWg5UmhmaFM3VTJrTWozZnYxTXVNY201T1RWczJjclkvdUdSdjN6dzJv?=
 =?utf-8?B?eVYwZFhTYnVhSGVBUE9xWjFZL0I1UjFkOUtQTThKQSthU05Ba0NDZm1pRUNL?=
 =?utf-8?B?eUVMRnlIUWczMEFURHhNVjFCcTB3Mk1PS2F5NUJVNjdyS3drSFN3clZqOUo4?=
 =?utf-8?B?WkdQOVNwczFYeDJmNHRxckhUOEZFSmFkZzJlbWp0blRJOFJqbzNZNTVYZHFz?=
 =?utf-8?B?eEwwRW1LQWNiMktuOCt0Qml5THEzVkg4U2I1ZVdwRjRYeVBVaEloMnFUSzYx?=
 =?utf-8?B?UFlmZnM2ck0wSVU3cHIwZmp2SXlpRUpUcjlKNTl4bkg5MHZudzJ2TGV3UTU5?=
 =?utf-8?B?SkhzMDVCdG15Wi9uYjA5UUVnTHRQcTlzODdWTjMvMHZXdEg3N3ViT2ViMEVi?=
 =?utf-8?B?K0VpYmV2VzRSV3pxdGErZlQ4MExKalFvKzNMSnd1TDZRSGlibk5XQUlWcStX?=
 =?utf-8?B?d0F5RWw2QzY0R1EwbnlIdWszNnFwd3E1YlJyQ2cvUzY2RmJkeEtaTlJsWTU5?=
 =?utf-8?B?VXd5emNwWDNQOFBLcFBrdVlBQ29OMEgvZFFsVVQ3L1pxNERJeHhyQ0tiZW95?=
 =?utf-8?B?TjJXRzhMZFlnWmFwNW1Ic0x5WEZEWXhIUU56QVdmbS9Md0FXZFZxZTYrV1Nk?=
 =?utf-8?B?WGQ4SEJmb2t5K1RIQ2ZJTEl5MzlDWUNVQUJwRno2U0hEZHo1akRmbUVHOGpJ?=
 =?utf-8?B?ekYxMEJHa3FpTEhPWWd3OXZNZkJmMFFyZmxPNENnMUZFQ1RVNUVrY3p6RW4r?=
 =?utf-8?B?aSs3WVFyK2g4UDJuU2ltdHlsakJPQlNhOThPdTlScXE1ZGs1RUFqQkU1R2xD?=
 =?utf-8?B?RDllc25QL0pic1grcHRiNTY1VTJTMHRLOGFwMk4veTVlN29lNUZ3bjROZm5l?=
 =?utf-8?B?WktUUUczekVPT1RLRk1vaEQ5R0ZWaVRRSHd0bklpTkdUUzBleW8xM2U4dU9S?=
 =?utf-8?B?WlJ6bGZ4ZFJSSXJwTW5Rd3dXYXV4TFgya1F2anZDWjBLdjBWanZzVko5WlRx?=
 =?utf-8?B?aFA4QmV2ZjhlcW1VbXJKSTMrZUt6Q2xUMFg2c25temhqcmx3akpxdEpGQ1lw?=
 =?utf-8?B?K0RSQVhXdEhDY2FDZnJ3K0dKS2xheWxhd0s0aW5kWTIwMTg2RVdEeWRQOGxO?=
 =?utf-8?B?RjR1R2M2d2t5VDMwSzBoSHJjTjhJUGlsMW16NFZJbS96NWZjOGE4elN5QXdy?=
 =?utf-8?B?Z0xPdlhoR1o4UGQwMkk2NDBUbTRLWkszdFh1N3Y1SGR5YTBsOTU5enlqRFYy?=
 =?utf-8?B?ZEZTOHROc3ZFZHd2U2pZSldHQ0Z4K1NHeU1mRW1heFdNMWEwM0x3d3JNMnps?=
 =?utf-8?B?TWFYT21NOFV2emdaU2hXTGFOU2t2K08rVW1YelpUZFBBMnREL3ZOV3dBWnRQ?=
 =?utf-8?B?bEZiUiswdElieFhQT0hxeTJNYnQvS3BwVXFGT2NiRk82c3Y5Y09GOXU2T3Z2?=
 =?utf-8?B?SmNNK01nTnYxVXlmNTFac0ZmUVZlcTZvVkNTZnVibzl5V2pjeTczTTM5WTMx?=
 =?utf-8?B?aDRIK3E2NElZZ2llWHFNYlBtZVpvbWJmdmlXUGpwY1BJdTRLQ2txRDJPbG9v?=
 =?utf-8?B?Q2h1c3BaR0NqbGVvSktya2VPTUlmTTBsTmJSYTlLWDBuTFdkQ1FhaWFFUlAx?=
 =?utf-8?B?cTIvT2FBSWVHLysxWEhna294OXU4ZHZ6ZlllZVZiMFYrOEhoZ2ZUWC9wWXdL?=
 =?utf-8?B?d1VFVmY1cy84YW03dTUwUVNVZW9xY2FwUlRwcVllQUFKY0h4NXFuN0xJVlZU?=
 =?utf-8?B?TWpFOEhLUlVYNytmRDZkeGs1cm5TYS9VM1FJTjVtSDl4UHFPVXVqRWFtSWNt?=
 =?utf-8?B?cGJ2OUxja2FnOW90QlJSUXhSM01oQnQzWkEreWljWEQ3NE4vZ0RIU1lCbjcy?=
 =?utf-8?B?Ym9DbkZMYlJ0UzMySnhENTU4VzB3N0NGQW5tVnQ0THJSbkgrSlcyMGRvMWEw?=
 =?utf-8?B?czFoSzRVclFhd1c2NkFCYXNURWh6eDdJbzYxKzN5R2RIcS9nUXRZRE5pdzhC?=
 =?utf-8?B?WDlxa2d1SkpSbDIzRWVDMGh0akpMV0kzdkNvbUJsU2t2clpWbm1RSDBDV1hi?=
 =?utf-8?B?RVkwUVJlQ3NVMGtJVHJ2QXVCZEovMVBOWUNpOEFQWGIvMG9sRi93K3ByTE9W?=
 =?utf-8?Q?cC40R3YGA6aKOCMQkR4KgsXuU?=
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5264.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026d3111-c38d-476f-8d07-08da663f7769
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 08:53:19.8256 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fA5NrqC5dDJwT97RE3tcGrKXkQmlj4wplayodSfIEyyGdSGNIZWIksH/VJzsGYwmTWQPMWi8tC3eolRV6JQ+2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2398
X-Proofpoint-GUID: 8M8Q0CNrH0EInIPYPEguHYNmn2mpfguB
X-Proofpoint-ORIG-GUID: 8M8Q0CNrH0EInIPYPEguHYNmn2mpfguB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_03,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam
 policy=outbound_active_cloned score=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 mlxlogscore=860 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207150038
X-Mailman-Approved-At: Fri, 15 Jul 2022 07:34:06 -0400
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3168061930991351222=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============3168061930991351222==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM4PR12MB5264D795F72137498EF87971B18B9DM4PR12MB5264namp_"

--_000_DM4PR12MB5264D795F72137498EF87971B18B9DM4PR12MB5264namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8hDQoNClRoZSBjb21tZW50IGZvciBrdm1faGFuZGxlX2d1ZXN0X2RlYnVnIHN0YXRlcyB0
aGF0IGl0IGlzIHVwIHRvIHRoZSB1c2Vyc3BhY2UgdG8gcmUtaW5qZWN0IGRlYnVnIGV4Y2VwdGlv
bnMgZm9yIHRoZSBndWVzdCB3aGVuIHRoZXkgYXJlIG5vdCDigJx1c2Vk4oCdIGJ5IHVzZXJzcGFj
ZS4NCg0KT24geDg2LCB0aGlzIGlzIGEgZmFpcmx5IHNpbXBsZSBwcm9jZXNzIHRoYXQgdXNlcyBL
Vk1fU0VUX1ZDUFVfRVZFTlRTLiBEb2VzIHRoaXMgd29yayBzaW1pbGFybHkgb24gQVJNPyBJcyB0
aGVyZSBzb21lIHNhbXBsZSBjb2RlIG9yIGRlc2NyaXB0aW9uIHdoaWNoIHN0ZXBzIGFyZSBuZWNl
c3NhcnkgZm9yIHRoYXQgcmUtaW5qZWN0aW9uPyBRRU1VIHVzZXMgaXRzIGdlbmVyaWMgaW50ZXJy
dXB0IG1hY2hpbmVyeSwgd2hpY2ggbWFrZXMgaXQgaGFyZCB0byBkZXRlcm1pbmUgd2hhdCBhcmUg
dGhlIG5lY2Vzc2FyeSBzdGVwcyB0byByZS1pbmplY3QgdGhlIGV4Y2VwdGlvbiBpbnRvIHRoZSBn
dWVzdC4NCg0KVGhhbmtzIGZvciB5b3VyIGFzc2lzdGFuY2UhDQoNClN0ZXBoYW4NCi0tDQpQcmlu
Y2lwYWwgQXJjaGl0ZWN0LCBTeW5vcHN5cyBHbWJILCBELTUyMDcyIEFhY2hlbg0KU2l0eiBkZXIg
R2VzZWxsc2NoYWZ0OiBBc2NoaGVpbSwgTGFuZGtyZWlzIE3DvG5jaGVuIOKAkyBSZWNodHNmb3Jt
OiBHbWJIIC0gQW10c2dlcmljaHQgTcO8bmNoZW4gSFJCIDkwOTQ5IOKAkyBWQVQvIFVTdC1sZCBO
ci4gREUxMjk0NzAzNzANCkdlc2Now6RmdHNmw7xocmVyOiAgIEdyZWdvciBXaWV0aGFsZXIsIFBy
b2YuIERyLiBBbmRyZWFzIEhvZmZtYW5uLCBMdWlzYSBEaW9nbywgT3JsYSBBbm5lIE11cnBoeQ0K
DQo=

--_000_DM4PR12MB5264D795F72137498EF87971B18B9DM4PR12MB5264namp_
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

PGh0bWwgeG1sbnM6dj0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWwiIHhtbG5zOm89InVy
bjpzY2hlbWFzLW1pY3Jvc29mdC1jb206b2ZmaWNlOm9mZmljZSIgeG1sbnM6dz0idXJuOnNjaGVt
YXMtbWljcm9zb2Z0LWNvbTpvZmZpY2U6d29yZCIgeG1sbnM6bT0iaHR0cDovL3NjaGVtYXMubWlj
cm9zb2Z0LmNvbS9vZmZpY2UvMjAwNC8xMi9vbW1sIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv
VFIvUkVDLWh0bWw0MCI+DQo8aGVhZD4NCjxtZXRhIGh0dHAtZXF1aXY9IkNvbnRlbnQtVHlwZSIg
Y29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PXV0Zi04Ij4NCjxtZXRhIG5hbWU9IkdlbmVyYXRv
ciIgY29udGVudD0iTWljcm9zb2Z0IFdvcmQgMTUgKGZpbHRlcmVkIG1lZGl1bSkiPg0KPHN0eWxl
PjwhLS0NCi8qIEZvbnQgRGVmaW5pdGlvbnMgKi8NCkBmb250LWZhY2UNCgl7Zm9udC1mYW1pbHk6
IkNhbWJyaWEgTWF0aCI7DQoJcGFub3NlLTE6MiA0IDUgMyA1IDQgNiAzIDIgNDt9DQpAZm9udC1m
YWNlDQoJe2ZvbnQtZmFtaWx5OkNhbGlicmk7DQoJcGFub3NlLTE6MiAxNSA1IDIgMiAyIDQgMyAy
IDQ7fQ0KLyogU3R5bGUgRGVmaW5pdGlvbnMgKi8NCnAuTXNvTm9ybWFsLCBsaS5Nc29Ob3JtYWws
IGRpdi5Nc29Ob3JtYWwNCgl7bWFyZ2luOjBjbTsNCglmb250LXNpemU6MTEuMHB0Ow0KCWZvbnQt
ZmFtaWx5OiJDYWxpYnJpIixzYW5zLXNlcmlmOw0KCW1zby1mYXJlYXN0LWxhbmd1YWdlOkVOLVVT
O30NCnNwYW4uRW1haWxTdHlsZTE3DQoJe21zby1zdHlsZS10eXBlOnBlcnNvbmFsLWNvbXBvc2U7
DQoJZm9udC1mYW1pbHk6IkNhbGlicmkiLHNhbnMtc2VyaWY7DQoJY29sb3I6d2luZG93dGV4dDt9
DQouTXNvQ2hwRGVmYXVsdA0KCXttc28tc3R5bGUtdHlwZTpleHBvcnQtb25seTsNCglmb250LWZh
bWlseToiQ2FsaWJyaSIsc2Fucy1zZXJpZjsNCgltc28tZmFyZWFzdC1sYW5ndWFnZTpFTi1VUzt9
DQpAcGFnZSBXb3JkU2VjdGlvbjENCgl7c2l6ZTo2MTIuMHB0IDc5Mi4wcHQ7DQoJbWFyZ2luOjcy
LjBwdCA3Mi4wcHQgNzIuMHB0IDcyLjBwdDt9DQpkaXYuV29yZFNlY3Rpb24xDQoJe3BhZ2U6V29y
ZFNlY3Rpb24xO30NCi0tPjwvc3R5bGU+PCEtLVtpZiBndGUgbXNvIDldPjx4bWw+DQo8bzpzaGFw
ZWRlZmF1bHRzIHY6ZXh0PSJlZGl0IiBzcGlkbWF4PSIxMDI2IiAvPg0KPC94bWw+PCFbZW5kaWZd
LS0+PCEtLVtpZiBndGUgbXNvIDldPjx4bWw+DQo8bzpzaGFwZWxheW91dCB2OmV4dD0iZWRpdCI+
DQo8bzppZG1hcCB2OmV4dD0iZWRpdCIgZGF0YT0iMSIgLz4NCjwvbzpzaGFwZWxheW91dD48L3ht
bD48IVtlbmRpZl0tLT4NCjwvaGVhZD4NCjxib2R5IGxhbmc9ImVuLURFIiBsaW5rPSIjMDU2M0Mx
IiB2bGluaz0iIzk1NEY3MiIgc3R5bGU9IndvcmQtd3JhcDpicmVhay13b3JkIj4NCjxkaXYgY2xh
c3M9IldvcmRTZWN0aW9uMSI+DQo8cCBjbGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJFTi1V
UyI+SGVsbG8hPG86cD48L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNw
YW4gbGFuZz0iRU4tVVMiPjxvOnA+Jm5ic3A7PC9vOnA+PC9zcGFuPjwvcD4NCjxwIGNsYXNzPSJN
c29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIj5UaGUgY29tbWVudCBmb3Iga3ZtX2hhbmRsZV9n
dWVzdF9kZWJ1ZyBzdGF0ZXMgdGhhdCBpdCBpcyB1cCB0byB0aGUgdXNlcnNwYWNlIHRvIHJlLWlu
amVjdCBkZWJ1ZyBleGNlcHRpb25zIGZvciB0aGUgZ3Vlc3Qgd2hlbiB0aGV5IGFyZSBub3Qg4oCc
dXNlZOKAnSBieSB1c2Vyc3BhY2UuPG86cD48L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1z
b05vcm1hbCI+PHNwYW4gbGFuZz0iRU4tVVMiPjxvOnA+Jm5ic3A7PC9vOnA+PC9zcGFuPjwvcD4N
CjxwIGNsYXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIj5PbiB4ODYsIHRoaXMgaXMg
YSBmYWlybHkgc2ltcGxlIHByb2Nlc3MgdGhhdCB1c2VzIEtWTV9TRVRfVkNQVV9FVkVOVFMuIERv
ZXMgdGhpcyB3b3JrIHNpbWlsYXJseSBvbiBBUk0/IElzIHRoZXJlIHNvbWUgc2FtcGxlIGNvZGUg
b3IgZGVzY3JpcHRpb24gd2hpY2ggc3RlcHMgYXJlIG5lY2Vzc2FyeSBmb3IgdGhhdCByZS1pbmpl
Y3Rpb24/IFFFTVUgdXNlcyBpdHMgZ2VuZXJpYyBpbnRlcnJ1cHQNCiBtYWNoaW5lcnksIHdoaWNo
IG1ha2VzIGl0IGhhcmQgdG8gZGV0ZXJtaW5lIHdoYXQgYXJlIHRoZSBuZWNlc3Nhcnkgc3RlcHMg
dG8gcmUtaW5qZWN0IHRoZSBleGNlcHRpb24gaW50byB0aGUgZ3Vlc3QuPG86cD48L286cD48L3Nw
YW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iRU4tVVMiPjxvOnA+Jm5i
c3A7PC9vOnA+PC9zcGFuPjwvcD4NCjxwIGNsYXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVO
LVVTIj5UaGFua3MgZm9yIHlvdXIgYXNzaXN0YW5jZSE8bzpwPjwvbzpwPjwvc3Bhbj48L3A+DQo8
cCBjbGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJFTi1VUyI+PG86cD4mbmJzcDs8L286cD48
L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iRU4tVVMiPlN0ZXBo
YW48L3NwYW4+PHNwYW4gbGFuZz0iZW4tREUiPjxvOnA+PC9vOnA+PC9zcGFuPjwvcD4NCjxwIGNs
YXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIiBzdHlsZT0iZm9udC1zaXplOjEwLjBw
dDttc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+LS0NCjxvOnA+PC9vOnA+PC9zcGFuPjwvcD4N
CjxwIGNsYXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIiBzdHlsZT0iZm9udC1zaXpl
OjEwLjBwdDttc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+UHJpbmNpcGFsIEFyY2hpdGVjdCwg
U3lub3BzeXMgR21iSCwgRC01MjA3MiBBYWNoZW48bzpwPjwvbzpwPjwvc3Bhbj48L3A+DQo8cCBj
bGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJERSIgc3R5bGU9ImZvbnQtc2l6ZTo4LjBwdDtt
c28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+U2l0eiBkZXIgR2VzZWxsc2NoYWZ0OiBBc2NoaGVp
bSwgTGFuZGtyZWlzIE3DvG5jaGVuIOKAkyBSZWNodHNmb3JtOiBHbWJIIC0gQW10c2dlcmljaHQg
TcO8bmNoZW4gSFJCIDkwOTQ5IOKAkyBWQVQvIFVTdC1sZCBOci4gREUxMjk0NzAzNzA8L3NwYW4+
PHNwYW4gbGFuZz0iREUiIHN0eWxlPSJtc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+PG86cD48
L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iREUiIHN0
eWxlPSJmb250LXNpemU6OC4wcHQ7bXNvLWZhcmVhc3QtbGFuZ3VhZ2U6IzIwMDAiPkdlc2Now6Rm
dHNmw7xocmVyOiZuYnNwOyAmbmJzcDtHcmVnb3IgV2lldGhhbGVyLCBQcm9mLiBEci4gQW5kcmVh
cyBIb2ZmbWFubiwgTHVpc2EgRGlvZ28sIE9ybGEgQW5uZSBNdXJwaHk8bzpwPjwvbzpwPjwvc3Bh
bj48L3A+DQo8cCBjbGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJlbi1ERSI+PG86cD4mbmJz
cDs8L286cD48L3NwYW4+PC9wPg0KPC9kaXY+DQo8L2JvZHk+DQo8L2h0bWw+DQo=

--_000_DM4PR12MB5264D795F72137498EF87971B18B9DM4PR12MB5264namp_--

--===============3168061930991351222==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3168061930991351222==--
