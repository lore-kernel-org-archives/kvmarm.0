Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53CAC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 12:59:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4298E2067C
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 12:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="abfE9VhO";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="abfE9VhO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4298E2067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E914BA80;
	Wed, 19 Aug 2020 08:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id berAg08qMlSL; Wed, 19 Aug 2020 08:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB504BA8E;
	Wed, 19 Aug 2020 08:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B504BA7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 08:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KRWbeEiYm99x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 08:59:12 -0400 (EDT)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30055.outbound.protection.outlook.com [40.107.3.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFDB04BA79
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 08:59:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SMMQbSx+ksBgWTfTO9apqIrlmn8I5S/P+QjfNFrp94=;
 b=abfE9VhOVlMqMHw5f6eqQlTppx/n4G7kanK3peiB5YHFyC3fxNEFjfDXxjlSTMXaGdHg7mdy9EfE2gXV7o1frhJPmW//MSG3QmobkrE3H7PtctUVaYU2Adj3DrvNCc5d5M5bpBXIztTyJvlNeoTzhZM4ZDa9VgjVtmzENY0WqCQ=
Received: from AM6PR10CA0003.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::16)
 by DB8PR08MB5131.eurprd08.prod.outlook.com (2603:10a6:10:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 12:59:09 +0000
Received: from VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::5d) by AM6PR10CA0003.outlook.office365.com
 (2603:10a6:209:89::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Wed, 19 Aug 2020 12:59:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT058.mail.protection.outlook.com (10.152.19.86) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 12:59:08 +0000
Received: ("Tessian outbound e8cdb8c6f386:v64");
 Wed, 19 Aug 2020 12:59:08 +0000
X-CR-MTA-TID: 64aa7808
Received: from c159c1ad27bb.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 90658EE3-E10E-4616-B0EE-2D28435DFC50.1; 
 Wed, 19 Aug 2020 12:59:03 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c159c1ad27bb.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 19 Aug 2020 12:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvpcjT926hwhgaLLuj9QeQ3tlIDnZkWPIdd5XvKQzN/ARD4pWN9++Dvvl3JBNEkgbqKbY4QlKAA4zAu1S1XKXvdngoh+k+kSeucF82dAzpZ0612X+c+Oq78ta2fKhq6TmoLkrKzno9plThKBEXcfAOUGQncTDBqivmBdaxUuUgoxl2j1tYUiWX27JPelXwixX1xZ7OfmG4v0z2bCDvd5OSd1oIIsdhzrVc87zr4o6RBSEQAVjkUi6pZs+zzZq0fZDhSU6Rd8LdYF04yYl0Sh0Hv41IKW5wLEbpODwDdU/y2oeOIga6cE4QU+wpPsft/71EqU5qVGKbDXp+rNkJwiWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SMMQbSx+ksBgWTfTO9apqIrlmn8I5S/P+QjfNFrp94=;
 b=EXdLsX7y6u8FRQ3wtzRk5VgwsSLlAzjhY4eD0ElEe2gLEjrK94V5ynDIX6wDlQXdMD/gtbzI7cEKnnnnwsPeldh4HH+2fZD5tNg2ujzxDV5hwVXiYD5gumio1I1G270Ol2izlJbNwbwVpqb7iVZ4JATZZ0pwvTMfN+astPDeLEq3HQoPo8dNXapqwUhyFEFIc0WFV1wwI/rtmVkOl29SbZ4cxAD423paA0BajBQ9pj8p1okekVDb8Fz7H6otfHukulWxmF6l4/E1oE2HUbpdodJt4teK6kCpbaXimdxUCY529RAsjKsJe76Rla5VCwBywz99IvZwWUOTwH5G+OoOYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SMMQbSx+ksBgWTfTO9apqIrlmn8I5S/P+QjfNFrp94=;
 b=abfE9VhOVlMqMHw5f6eqQlTppx/n4G7kanK3peiB5YHFyC3fxNEFjfDXxjlSTMXaGdHg7mdy9EfE2gXV7o1frhJPmW//MSG3QmobkrE3H7PtctUVaYU2Adj3DrvNCc5d5M5bpBXIztTyJvlNeoTzhZM4ZDa9VgjVtmzENY0WqCQ=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1722.eurprd08.prod.outlook.com (2603:10a6:3:87::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 12:58:58 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0%5]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 12:58:58 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Topic: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Index: AQHWa1Xu75d1j9xetEK2hY75HyglSak/PN3ggAALmACAAAFIoIAACZ2AgAAmpjA=
Date: Wed, 19 Aug 2020 12:58:57 +0000
Message-ID: <HE1PR0802MB2555A41FE0435FCE8EDF7F8EF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
 <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
 <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <5dd5ccf145b366e562782f117f25d880@kernel.org>
In-Reply-To: <5dd5ccf145b366e562782f117f25d880@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 1C9047D31495EC44A661620DA3AD3F82.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [2409:8a1e:6c6d:bd10:253b:c89:1240:79a8]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b09bd66-ccda-4e7e-d283-08d8443fa96e
x-ms-traffictypediagnostic: HE1PR0801MB1722:|DB8PR08MB5131:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5131A8699F542ADDCD60CABEF45D0@DB8PR08MB5131.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:651;OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EADkXhqFKtBfV/gU67pFACKHaLsvR4IiIeC5x4QzxBL9upthSF3+TatuioWoHXVDWB/J9xJwf6WHYc8eNFWjOy2UDdi9QfbRFWniVOUhlTadXYHg2+BTZoj1KpcTncZynVvZcicJUnFPFE+/qGMmh5mo6EJmb+pkXD+LII2a6xyzc/wrKuqXTudKuUUQcvYpUOfOkT3mA9/JaC+p4Ctx8+Ewjfzy7n5P9hOjvVIjwYbVx2QkfVD3DxQzkuG7fQWkuBIRgmWUedQ02S/BrLseKG3M3pvDC6VqG1SlScGBCz7HWoy7PdOHr+vxkE7VL8+ZuHNxu80fCes1CdgEpA6pwwMU3s1e8RAxwyw1cmVYEFcLqLv/E6A4yJ3Hiv73WLbhZ7KJ1JHk3utxAxksaj9/tw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(66556008)(4326008)(5660300002)(66946007)(86362001)(76116006)(8936002)(2906002)(66446008)(66476007)(52536014)(64756008)(186003)(966005)(55016002)(9686003)(53546011)(316002)(478600001)(54906003)(6506007)(83380400001)(8676002)(6916009)(33656002)(71200400001)(7696005);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: EBBq2ApKATqHonVz5rFJJCIlpoFJ2Zuo5X9Ci5+abzLdJvAfvfwI7W/Q0Tf1AQIlLv5wCo0RQnRQBKhD8pHW1A6bsVE8p31FdCVTxj6DrEqcv3fGUFyByuJH+ur5Ktg4tlICqvBCAXLt+f3Sas0LpTj9/V30bTuq5d62dMo+ZBOWVnNF79YaktpqnBFVpH0IiUCP7xp0NsmomDn+8NKPbFblT0ODAZaz6wG9bvXVwtWC3M7RBLI/MWLpSo2LSOXXxXsWN5pjrvoOuiB/m0LBCGJ8NcdO8Pfo6Nw+zOt2n1VdZKaNU3unrUE5lfGWosG6W5rAWz3pFCBKXftMjMCOdncc8H0bYZg/XWx9+nfNl7SjHE7Hgyp7d1/SXh3crFjSS/I0dLlHQEK5ZU7n6RtklZ1I9Dx/tFv0ByBQNW0Oq6vv5ePlEwDN0lOiRwJXIIO+NKDQ+t1APMm9Oy78sgRLD4LLgcYkGZ3TYHetkbqfV25WqPoFHkdh+OVz1dbf7yXwaKCQR8/rfmuP/4osM125TZpYT6ulOZRl3dN9zCl5Dv6pPM8pi9evtrWOjkibudvaOqz01+J75EFLNZ0rJZSMZ9YFECnKjwgrV7PT9XQ4E1NDL9NZj4IuC7pJth0ZFpea3+YPUGI0BferTpw4Mt0uyFmswwN+e+lhIs2ktHTDT9Rqo07ucCS04n5s9KfUTrLdp6Wt6K/SVIKbFlEzJOurfw==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1722
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 298008af-e5ec-4857-ec63-08d8443fa30c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NT41VU6Aor/VNWtSbsEvrmHyxj+Ui5rDFDPb8cvqcEAloDL5C1R1nuGfk8oiqh+9u+fKslJmE1ncRLq2/Fqkp5C0CMBwwpqg8kJ7x/A3sIzEGV7sTNEgBKQswbMX+fpGnoCYOfJg9XXidejVZGzQXNylUtSTq/T1QjWRartTe/JaUJ8fz6Cy3b6lyR0TiI/87WHHdusPfJ/7ePWE7McZ4YG0Bua2wbJmysgJKAMAU6oSZKIuTG7QpgpCfHvYxdch8oErwslsyyZFLzXL2w8AuN9H1RRLf+5Nb6+UOicCaKrU2BeCZ5f1dSqHkDtyJbZ+FchSOh+PJyvdjaDa8fJuYWXsKBuYU+O8jAIcZ0aDpoGzwOEuzIAEU3BgaaesRflG33fCcwDzJCSPu/2SRTlq+PaIMCniOrPrUOOFEjzYaG/6+KDwglPNV00m0DFQEozYCcfKbKzkIFe3P7nCgLEx1sgo18m6zkCUe/sVB7vlqUQ=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966005)(36906005)(966005)(316002)(54906003)(107886003)(70586007)(53546011)(83380400001)(5660300002)(52536014)(70206006)(6506007)(33656002)(186003)(8676002)(2906002)(8936002)(336012)(9686003)(47076004)(81166007)(55016002)(4326008)(356005)(82740400003)(26005)(82310400002)(86362001)(478600001)(7696005)(6862004);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 12:59:08.8066 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b09bd66-ccda-4e7e-d283-08d8443fa96e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5131
Cc: Peng Hao <richard.peng@oppo.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 Alexander Graf <graf@amazon.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Wednesday, August 19, 2020 6:39 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
> <richard.peng@oppo.com>; kernel-team@android.com; kvm@vger.kernel.org;
> Will Deacon <will@kernel.org>; Catalin Marinas <Catalin.Marinas@arm.com>;
> Alexander Graf <graf@amazon.com>; kvmarm@lists.cs.columbia.edu; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
> sys_regs file
> 
> On 2020-08-19 11:18, Jianyong Wu wrote:
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Wednesday, August 19, 2020 6:00 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
> >> <richard.peng@oppo.com>; kernel-team@android.com;
> >> kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> >> <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> >> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> >> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers
> >> to the sys_regs file
> >>
> >> On 2020-08-19 10:24, Jianyong Wu wrote:
> >> > Hi Marc,
> >> >
> >> > -----Original Message-----
> >> > From: kvmarm-bounces@lists.cs.columbia.edu
> >> > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
> >> > Sent: Thursday, August 6, 2020 1:57 AM
> >> > To: Paolo Bonzini <pbonzini@redhat.com>
> >> > Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com;
> >> > kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> >> > <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> >> > kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> >> > Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to
> >> > the sys_regs file
> >> >
> >> > Move the timer gsisters to the sysreg file. This will further help
> >> > when they are directly changed by a nesting hypervisor in the VNCR
> >> > page.
> >> >
> >> > This requires moving the initialisation of the timer struct so that
> >> > some of the helpers (such as arch_timer_ctx_index) can work
> >> > correctly at an early stage.
> >> >
> >> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> > ---
> >> >  arch/arm64/include/asm/kvm_host.h |   6 ++
> >> >  arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
> >> >  arch/arm64/kvm/trace_arm.h        |   8 +-
> >> >  include/kvm/arm_arch_timer.h      |  11 +--
> >> >  4 files changed, 136 insertions(+), 44 deletions(-)
> >> >
> >> > +static u64 timer_get_offset(struct arch_timer_context *ctxt) {
> >> > +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> >> > +
> >> > +	switch(arch_timer_ctx_index(ctxt)) {
> >> > +	case TIMER_VTIMER:
> >> > +		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> >> > +	default:
> >> > +		return 0;
> >> > +	}
> >> > +}
> >> > +
> >> > Can I export this helper? As in my ptp_kvm implementation I need
> >> > get VCNT offset value separately not just give me a result of VCNT.
> >>
> >> Sorry, you need to give me a bit more context. What do you need the
> >> offset for exactly?
> >
> > Yeah,
> > In my ptp_kvm implementation, I need acquire wall time and counter
> > cycle in the same time in host. After get host counter cycle, I need
> > subtract it by VCNT offset to obtain VCNT. See
> > https://lkml.org/lkml/2020/6/19/441
> > https://lkml.org/lkml/2020/6/19/441
> > But now I can't get the VCNT offset easily like before using "
> > vcpu_vtimer(vcpu)->cntvoff" and I can't use the helper like
> > "kvm_arm_timer_read" as I need acquire the counter cycle in the same
> > time with the host wall time.
> 
> I must be missing something. CNTVOFF_EL2 is now implemented as a standard
> system register, and has the same visibility as any other vcpu sysreg.
> 
> Why doesn't vcpu_read_sys_reg(vcpu, CNTVOFF_EL2) work for you?

Maybe it serves me, let me try it, thanks.

Thanks
Jianyong
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
