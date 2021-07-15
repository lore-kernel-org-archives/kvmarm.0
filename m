Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64849C47E48
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:39:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2086613BF
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 10:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2086613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99A3B4B0BE;
	Thu, 15 Jul 2021 06:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oLi65JAS66BD; Thu, 15 Jul 2021 06:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E944B0BC;
	Thu, 15 Jul 2021 06:38:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE2249F82
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 05:44:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kv+ZtnAvKWUP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 05:44:45 -0400 (EDT)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF21C4099E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 05:44:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1626342283;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v9pgcUlEz74IZTdHdaUXk5JLYSOmI68SSuZr5ztBIPI=;
 b=DeYVsOGjZst+Z7zLUpSP6QzYz7ecwPdp8prELneklHrw6cCel317Wzoe0x7APCCLCoVQoN
 FKY86mjdnLohk+0ES34lGRMiAtLml8xDu+z7uu6fYSSJ9yeE2zh8hHhq5cjs04AKx+Q9TI
 mWaInd/S3LEdXtb70Ol/pR78rcFRK3I=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-6CvbyWXlOu2E9xYOXVRhgw-1; Thu, 15 Jul 2021 11:44:42 +0200
X-MC-Unique: 6CvbyWXlOu2E9xYOXVRhgw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htlT7jwk9sOSow4aUXIFpbZwc13B+BsQRfrwnUtnyW9cmQRJeMsX9AH3KYFlDG2JOalhtR3tIZbYxhkFbChA3GgW/cA05iVSBe0ybZBvsr6/X1alSXsDIpa1jZBHkbQp23EXz5Pa7V6Mg5PcH+oFKKKGEMd87BboWMNl+tzfrwDcWkt9M27wjqeSr68+EJLJJ5ib2rEVOaMZzCgbw72CwwRyeu5y5ZbBDFbwVDXZOjXzBt/V6ho72xRHscj5EB0t5mKqAOLn4oXzDrpDoYhbSwSB6yItHHrZuvKAMQMHJv7mboMS6zafyA/zXEGaKnD3+BqFJs3wyKMg3nLT0V6oXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TX6RsXvp0ZJt2BckOx6Z2HNd6qG46qG8BpY4QoW8Kak=;
 b=I2ciWx+CCbzSPaQ/EV/i1F4tEITcEaGNR/niHGnUMrDcS4r1KyGUhPtTY89YsZMvYFTIXzB7zWRY1k7mWBMo2laCTlTpER389pPpEqK6OTRIsvbjVnPjImXSZvXuN6ATzqy/wEJvRq7zGPpXJbYs4hdtxeWfRzgstyRZvEi6ePyz56RF9aphHQcunKBMplvlnpowuL+P+E6MD98jQBZPhg7QnMdBCME37lSIlAmoItmoMPcE5QrsQx7qjj9ADpBQART9pSSxhbQ5Zkj1kgNoi9qUBXRteSLy6hWv0oOJbHgMSUpjfriGL+uYijg+Nun6L/7EsdrzcWkkNSKKWrPQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM7PR04MB7015.eurprd04.prod.outlook.com (2603:10a6:20b:117::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 09:44:41 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65%3]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 09:44:41 +0000
To: Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
From: Qu Wenruo <wqu@suse.com>
Subject: Re: Any way to disable KVM VHE extension?
Message-ID: <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
Date: Thu, 15 Jul 2021 17:44:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
Content-Language: en-US
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To AM7PR04MB6821.eurprd04.prod.outlook.com
 (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by
 BYAPR06CA0041.namprd06.prod.outlook.com (2603:10b6:a03:14b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Thu, 15 Jul 2021 09:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b7e425-02d0-4e6a-2339-08d947752b5c
X-MS-TrafficTypeDiagnostic: AM7PR04MB7015:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7015786BB634ED40119A45E2D6129@AM7PR04MB7015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbpu1eXgjYQrhtNxQ/BLFN0K8/YSW3WE3szMFjTAZ0YWQoE+N/vEbsiYzkqte0h4PefRjtfa5+zUb4tGL1rJDge6TttNHxeF1yrt9vxDh2ZVf8uxY+fXlhuWwExMCK/HNQiM6XNQ6dt4yV5UGoo5QPml0Z2xPXGb1cQtsxi80oZv0jbvE1Ij16fJSPAqQLyPkDIEyg0XdkzCW0Hma773ZxE5TnWwSMezDLTWCLUCG68+468kFlX5RnF+n113+1kPNNVIbJZ060ollFvAqnko2b5k3lCukKWGgkgSRctZWEX4RJPLjj58dsUGaKcQh5WHiTNVJ8eh1C5Vos2ii4WyJwGTJGFId3AzI98BzuClQiYDfNrIrmplLz67lPxZ8f+xLqdHGEtccY1lapYkQ58qeuisl9dadFNyJEI5iUTdfKllK1bJjJrRKr2w/RdfjW4vWYw/qVYerKIU09kqqHUUtUru1gQ5ZXIT8mW2+QnlFBshmmUCgD0MaUefBzdsO/ZCdIMuqAjS1oByUQ7O4EgRLgmO1o+SKXSb5Ieq7b/3muLkGrRZxac94g+7bXHoiXaJru/m/CTgFfjRy1TbWVv6TMottqE/0hcYJzEOjsXS2ZvygYWMwu5rDU793S2Bz9hM+E0qCBJW9RZFHnHUligZCba+fSxbV8Lgwo0csDvQqomMkXSOzWcEcLNYs1OesZAV7REhpKoR143pGUVLLayFDn7ubjrGayX2XOQzTXRaGqgumfEnhrPR/daCs7K5z8iwUod7VNy+yrll5DC+8eICVNKdp2KG14AsccVRc4YdXz5S9jyQw7OqrlgYw+GHmkR0UvB4nM7IBVJDdS3lHWVLsw3/taFZ/Mmp2osZO9zZ8M0=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM7PR04MB6821.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(5660300002)(31696002)(2906002)(186003)(66946007)(956004)(66476007)(8676002)(31686004)(6486002)(316002)(26005)(66556008)(36756003)(86362001)(83380400001)(2616005)(16576012)(6706004)(6666004)(966005)(478600001)(110136005)(38100700002)(53546011)(8936002)(43043002)(78286007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nMksWXwhbmGJiOhco/oRiFpgZq3IP79i9YZDkwmz2rj2Yk8Jj6l00kuwWU7B?=
 =?us-ascii?Q?xdwYbuG4Un5XYwQbl50KFnIqvuLc9zA/EnFSgphizXMI5BbvWNBhJYxj0ud5?=
 =?us-ascii?Q?PEX/bIHsRsQynsIVWeJNjANhKVOpb9jUZj+KJtNw8Y/aEu0C+vyN19UqiZPO?=
 =?us-ascii?Q?ph3cblaANdMFLbJOgS10fHVJi57cdxswBfW+/xC/Xu10CIEXNiCwb5eeT2tr?=
 =?us-ascii?Q?N9BlnBplXr3WdRn85wvGhbS9mmCJQ+CCa92BaiXeFijBsKivv8iQvbOM93VE?=
 =?us-ascii?Q?q9OUm0Bzwgsq+bNs8eSbgN4wGkgghjUnzcly8r56w2wCrks7s8hfAAVG4Wf9?=
 =?us-ascii?Q?JMo9Y74jrxJBACVeqp7jhQ5b3k6twlZkHVROCM0shXNRq4hzgfV+AhfnMh92?=
 =?us-ascii?Q?a/+y7jh4mv0bYOms5Dtwl2OEa/zox2q0PnjOQ2qIbxlTJU0Drjpv/PsgJcNg?=
 =?us-ascii?Q?OwFAesAvXiVldhSuVcS+5VrAls4evvmeX59ZVmtFHd0K4bd0cdyhmRM6GEmO?=
 =?us-ascii?Q?byhSqEf/Tn8WSkO96xoOSOvNov+9BZ01GX8CYFQ/Jf8XXsD1UkKA+7bzm3P8?=
 =?us-ascii?Q?eCjLkaNY1HVkrY62tB7JeaoL9i0jhU434Mu5M37M25TyWyIn2RD3eE50GBiF?=
 =?us-ascii?Q?6ZsNVYvDQunrQEJAlPmlTSVco7jg4Fkeii7ivWHvxYhumQW6crwVbkBXF6Tf?=
 =?us-ascii?Q?m8l2CFNxqI21pBjPIkTJS9X1zLQY177IV+Ov5T1xCwMsvUvkk5ViJHdccpyw?=
 =?us-ascii?Q?KNkU6wAmEUAmwAhgkpyGs94HyuhNVvQ5Ho1xlD55+9vPYB6hpDzdV97oxElc?=
 =?us-ascii?Q?vw139mdKCnBQUUYVm9CeDXxGI8lMlTieswuKna/ORxTNZ4sS4wg7pXgXeexg?=
 =?us-ascii?Q?vuvZynpTTJFmALwC7HRkNfMshAWy51Smwn7OzHopcum+PvMvg59Ov4UQpGSm?=
 =?us-ascii?Q?p0TObnM3NN4BDm2SMvrRst1cZyD1J3c/elELi8g8lW97Vcw3bTvGTqRCBgk6?=
 =?us-ascii?Q?Inaij0vctq7850Jq1GnxGXvccKfytPfw+RwDtiJSTidHsHJgs9+01v0Wm3Zs?=
 =?us-ascii?Q?l4vQJxUtEUUXT1wz2Whr86XOfoqciQkRGz9E+DHJXZIVOUQhmLY95L0H+W33?=
 =?us-ascii?Q?Sz62PAuRFVUaSyuy6Ryv5wVBC2+aucCjAEJpbOrsnLZBkqcUbHCb4TRIZl+J?=
 =?us-ascii?Q?Uxr6yAxjo+LjsbGndWAeOdDnTGX/Hx6wSoxEeFuGiSlZusOF9xDeWGkbVkzJ?=
 =?us-ascii?Q?9P6MBw7EOHTsntMti0ANb8PQcNaX1SefTyQGYK4cxcpOJl900ZaHvgprw+/+?=
 =?us-ascii?Q?Sdb5rE+g21biTbsSW0ARCV7U?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b7e425-02d0-4e6a-2339-08d947752b5c
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 09:44:41.4776 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aai4LowXJ7KykwdhDhFhWULUOr1SH5cMmF35viPVZ+nggw4lMO9UO6a7CI06axa3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7015
X-Mailman-Approved-At: Thu, 15 Jul 2021 06:38:57 -0400
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyMDIxLzcvMTUg5LiL5Y2INToyOCwgUm9iaW4gTXVycGh5IHdyb3RlOgo+IE9uIDIwMjEt
MDctMTUgMDk6NTUsIFF1IFdlbnJ1byB3cm90ZToKPj4gSGksCj4+Cj4+IFJlY2VudGx5IEknbSBw
bGF5aW5nIGFyb3VuZCB0aGUgTnZpZGlhIFhhdmllciBBR1ggYm9hcmQsIHdoaWNoIGhhcyBWSEUg
Cj4+IGV4dGVuc2lvbiBzdXBwb3J0Lgo+Pgo+PiBJbiB0aGVvcnksIGNvbnNpZGVyaW5nIHRoZSBD
UFUgYW5kIG1lbW9yeSwgaXQgc2hvdWxkIGJlIHByZXR0eSAKPj4gcG93ZXJmdWwgY29tcGFyZWQg
dG8gYm9hcmRzIGxpa2UgUlBJIENNNC4KPj4KPj4gQnV0IHRvIG15IHN1cnByaXNlLCBLVk0gcnVu
cyBwcmV0dHkgcG9vciBvbiBYYXZpZXIuCj4+Cj4+IEp1c3QgYm9vdGluZyB0aGUgZWRrMiBmaXJt
d2FyZSBjb3VsZCB0YWtlIG92ZXIgMTBzLCBhbmQgMjBzIHRvIGZ1bGx5IAo+PiBib290IHRoZSBr
ZXJuZWwuCj4+IEV2ZW4gbXkgVk0gb24gUlBJIENNNCBoYXMgd2F5IGZhc3RlciBib290IHRpbWUs
IGV2ZW4ganVzdCBydW5uaW5nIG9uIAo+PiBQQ0lFMi4wIHgxIGxhbmUgTlZNRSwgYW5kIGp1c3Qg
NCAyLjFHaHogQTcyIGNvcmUuCj4+Cj4+IFRoaXMgaXMgZGVmaW5pdGVseSBvdXQgb2YgbXkgZXhw
ZWN0YXRpb24sIEkgZG91YmxlIGNoZWNrZWQgdG8gYmUgc3VyZSAKPj4gdGhhdCBpdCdzIHJ1bm5p
bmcgaW4gS1ZNIG1vZGUuCj4+Cj4+IEJ1dCBmdXJ0aGVyIGRpZ2dpbmcgc2hvd3MgdGhhdCwgc2lu
Y2UgWGF2aWVyIEFHWCBDUFUgc3VwcG9ydHMgVkhFLCBrdm0gCj4+IGlzIHJ1bm5pbmcgaW4gVkhF
IG1vZGUgb3RoZXIgdGhhbiBIWVAgbW9kZSBvbiBDTTQuCj4+Cj4+IElzIHRoZXJlIGFueXdheSB0
byBtYW51YWxseSBkaXNhYmxlIFZIRSBtb2RlIHRvIHRlc3QgdGhlIG1vcmUgY29tbW9uIAo+PiBI
WVAgbW9kZSBvbiBYYXZpZXI/Cj4gCj4gQWNjb3JkaW5nIHRvIGtlcm5lbC1wYXJhbWV0ZXJzLnR4
dCwgImt2bS1hcm0ubW9kZT1udmhlIiAob3IgaXRzIAo+IGxvdy1sZXZlbCBlcXVpdmFsZW50ICJp
ZF9hYTY0bW1mcjEudmg9MCIpIG9uIHRoZSBjb21tYW5kIGxpbmUgc2hvdWxkIGRvIAo+IHRoYXQu
CgpUaGFua3MgZm9yIHRoaXMgb25lLCBJIHN0dXBpZGx5IG9ubHkgc2VhcmNoZWQgbW9kaW5mbyBv
ZiBrdm0sIGFuZCBkaWRuJ3QgCmV2ZW4gYm90aGVyIHRvIHNlYXJjaCBhcmNoL2FybTY0L2t2bS4u
LgoKPiAKPiBIb3dldmVyIEknZCBpbWFnaW5lIHRoZSBkaXNjcmVwYW5jeSBpcyBsaWtlbHkgdG8g
YmUgc29tZXRoaW5nIG1vcmUgCj4gZnVuZGFtZW50YWwgdG8gdGhlIHdpbGRseSBkaWZmZXJlbnQg
bWljcm9hcmNoaXRlY3R1cmVzLiBUaGVyZSdzIAo+IGNlcnRhaW5seSBubyBoYXJtIGluIGdpdmlu
ZyBub24tVkhFIGEgZ28gZm9yIGNvbXBhcmlzb24sIGJ1dCBJIHdvdWxkbid0IAo+IGJlIHN1cnBy
aXNlZCBpZiBpdCB0dXJucyBvdXQgZXZlbiBzbG93ZXIuLi4KCllvdSdyZSB0b3RhbGx5IHJpZ2h0
LCB3aXRoIG52aGUgbW9kZSwgaXQncyBzdGlsbCB0aGUgc2FtZSBzbG93IHNwZWVkLgoKQlRXLCB3
aGF0IGRpZCB5b3UgbWVhbiBieSB0aGUgIndpbGRseSBkaWZmZXJlbnQgbWljcm9hcmNoIj8KSXMg
QVJNdjguMiBhcmNoIHRoYXQgZGlmZmVyZW50IGZyb20gQVJNdjggb2YgUlBJND8KCkFuZCBhbnkg
ZXh0cmEgbWV0aG9kcyBJIGNvdWxkIHRyeSB0byBleHBsb3JlIHRoZSByZWFzb24gb2YgdGhlIHNs
b3duZXNzPwoKQXQgbGVhc3QgUlBJIENNNCBpcyBiZXlvbmQgbXkgZXhwZWN0YXRpb24gYW5kIGlz
IHdvcmtpbmcgcHJldHR5IGZpbmUuCgpUaGFua3MsClF1Cgo+IAo+IFJvYmluLgo+IAo+PiBCVFcs
IHRoaXMgaXMgdGhlIGRtZXNnIHJlbGF0ZWQgdG8gS1ZNIG9uIFhhdmllciwgcnVubmluZyB2NS4x
MyAKPj4gdXBzdHJlYW0ga2VybmVsLCB3aXRoIDY0SyBwYWdlIHNpemU6Cj4+IFvCoMKgwqAgMC44
NTIzNTddIGt2bSBbMV06IElQQSBTaXplIExpbWl0OiA0MCBiaXRzCj4+IFvCoMKgwqAgMC44NTcz
NzhdIGt2bSBbMV06IHZnaWMgaW50ZXJydXB0IElSUTkKPj4gW8KgwqDCoCAwLjg2MjEyMl0ga3Zt
OiBwbXUgZXZlbnQgY3JlYXRpb24gZmFpbGVkIC0yCj4+IFvCoMKgwqAgMC44NjY3MzRdIGt2bSBb
MV06IFZIRSBtb2RlIGluaXRpYWxpemVkIHN1Y2Nlc3NmdWxseQo+Pgo+PiBXaGlsZSBvbiBDTTQs
IHRoZSBob3N0IHJ1bnMgdjUuMTIuMTAgdXBzdHJlYW0ga2VybmVsICh3aXRoIGRvd25zdHJlYW0g
Cj4+IGR0YiksIHdpdGggNEsgcGFnZSBzaXplOgo+PiBbwqDCoMKgIDEuMjc2ODE4XSBrdm0gWzFd
OiBJUEEgU2l6ZSBMaW1pdDogNDQgYml0cwo+PiBbwqDCoMKgIDEuMjc4NDI1XSBrdm0gWzFdOiB2
Z2ljIGludGVycnVwdCBJUlE5Cj4+IFvCoMKgwqAgMS4yNzg2MjBdIGt2bSBbMV06IEh5cCBtb2Rl
IGluaXRpYWxpemVkIHN1Y2Nlc3NmdWxseQo+Pgo+PiBDb3VsZCBpdCBiZSB0aGUgUEFHRSBzaXpl
IGNhdXNpbmcgcHJvYmxlbT8KPj4KPj4gVGhhbmtzLAo+PiBRdQo+Pgo+Pgo+PiBfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBsaW51eC1hcm0ta2VybmVs
IG1haWxpbmcgbGlzdAo+PiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKPj4g
aHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2Vy
bmVsCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
