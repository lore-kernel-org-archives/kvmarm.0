Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B882EC4708E
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 13:45:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D6540B75;
	Wed,  7 Dec 2022 08:45:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0qwi+vHgDGXl; Wed,  7 Dec 2022 08:45:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 758234B628;
	Wed,  7 Dec 2022 08:45:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6814B630
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 00:44:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GK1p8WVSO5Nz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 00:44:45 -0500 (EST)
Received: from out30-8.freemail.mail.aliyun.com
 (out30-8.freemail.mail.aliyun.com [115.124.30.8])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1282D4B3DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 00:44:44 -0500 (EST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R701e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=tianruidong@linux.alibaba.com; NM=0; PH=DS; RN=43; SR=0;
 TI=SMTPD_---0VWkBjQs_1670391876; 
Received: from 30.221.133.176(mailfrom:tianruidong@linux.alibaba.com
 fp:SMTPD_---0VWkBjQs_1670391876) by smtp.aliyun-inc.com;
 Wed, 07 Dec 2022 13:44:38 +0800
Message-ID: <b365db02-b28c-1b22-2e87-c011cef848e2@linux.alibaba.com>
Date: Wed, 7 Dec 2022 13:44:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] ACPI/AEST: Initial AEST driver
To: Tyler Baicar <baicar@amperemail.onmicrosoft.com>,
 "ishii.shuuichir@fujitsu.com" <ishii.shuuichir@fujitsu.com>,
 'Tyler Baicar' <baicar@os.amperecomputing.com>,
 "patches@amperecomputing.com" <patches@amperecomputing.com>,
 "abdulhamid@os.amperecomputing.com" <abdulhamid@os.amperecomputing.com>,
 "darren@os.amperecomputing.com" <darren@os.amperecomputing.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
 "rafael@kernel.org" <rafael@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "mark.rutland@arm.com"
 <mark.rutland@arm.com>, "anshuman.khandual@arm.com"
 <anshuman.khandual@arm.com>,
 "vincenzo.frascino@arm.com" <vincenzo.frascino@arm.com>,
 "tabba@google.com" <tabba@google.com>, "marcan@marcan.st"
 <marcan@marcan.st>, "keescook@chromium.org" <keescook@chromium.org>,
 "jthierry@redhat.com" <jthierry@redhat.com>,
 "masahiroy@kernel.org" <masahiroy@kernel.org>,
 "samitolvanen@google.com" <samitolvanen@google.com>,
 "john.garry@huawei.com" <john.garry@huawei.com>,
 "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>,
 "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
 "tmricht@linux.ibm.com" <tmricht@linux.ibm.com>,
 "dchinner@redhat.com" <dchinner@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Vineeth.Pillai@microsoft.com" <Vineeth.Pillai@microsoft.com>
References: <20211124170708.3874-1-baicar@os.amperecomputing.com>
 <20211124170708.3874-2-baicar@os.amperecomputing.com>
 <TYCPR01MB6160D05580A6E8C9510D25A5E9709@TYCPR01MB6160.jpnprd01.prod.outlook.com>
 <9330bbfb-d016-0283-a5ed-e2f4d5446759@amperemail.onmicrosoft.com>
 <TYCPR01MB616007723D2C8BA08F5337D2E9F59@TYCPR01MB6160.jpnprd01.prod.outlook.com>
 <7413d707-93a5-3681-e338-adebef198ec5@amperemail.onmicrosoft.com>
From: Ruidong Tian <tianruidong@linux.alibaba.com>
In-Reply-To: <7413d707-93a5-3681-e338-adebef198ec5@amperemail.onmicrosoft.com>
X-Mailman-Approved-At: Wed, 07 Dec 2022 08:45:16 -0500
Cc: xueshuai@linux.alibaba.com, baolin.wang@linux.alibaba.com
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

SGksIFR5bGVyLgoKSSBhbSB2ZXJ5IGludGVyZXN0ZWQgaW4geW91ciB3b3JrIGFib3V0IEFFU1Qu
CldoZW4gZG8geW91IHBsYW4gdG8gdXBkYXRlIHRoZSB2MiBwYXRjaCBzZXJpZXM/CgpCZXN0IHJl
Z2FyZHMuCgrlnKggMjAyMi81LzkgMjE6MzcsIFR5bGVyIEJhaWNhciDlhpnpgZM6Cj4gSGkgU2h1
dWljaGlyb3UsCj4KPiBJIHNob3VsZCBiZSBhYmxlIHRvIGdldCBhIHYyIHBhdGNoIHNlcmllcyBv
dXQgYnkgdGhlIGVuZCBvZiB0aGUgbW9udGguCj4KPiBUaGFua3MsCj4gVHlsZXIKPgo+IE9uIDQv
MjAvMjAyMiAzOjU0IEFNLCBpc2hpaS5zaHV1aWNoaXJAZnVqaXRzdS5jb20gd3JvdGU6Cj4+IEhp
LCBUeWxlci4KPj4KPj4gV2hlbiBkbyB5b3UgcGxhbiB0byBwb3N0IHRoZSB2MiBwYXRjaCBzZXJp
ZXM/Cj4+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgZG9uJ3QgbWluZC4KPj4KPj4gQmVzdCBy
ZWdhcmRzLgo+Pgo+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0KPj4+IEZyb206IFR5bGVy
IEJhaWNhciA8YmFpY2FyQGFtcGVyZW1haWwub25taWNyb3NvZnQuY29tPgo+Pj4gU2VudDogRnJp
ZGF5LCBEZWNlbWJlciAxNywgMjAyMSA4OjMzIEFNCj4+PiBUbzogSXNoaWksIFNodXVpY2hpcm91
L+efs+S6lSDlkajkuIDpg44gPGlzaGlpLnNodXVpY2hpckBmdWppdHN1LmNvbT47ICdUeWxlciAK
Pj4+IEJhaWNhcicKPj4+IDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5nLmNvbT47IHBhdGNoZXNA
YW1wZXJlY29tcHV0aW5nLmNvbTsKPj4+IGFiZHVsaGFtaWRAb3MuYW1wZXJlY29tcHV0aW5nLmNv
bTsgZGFycmVuQG9zLmFtcGVyZWNvbXB1dGluZy5jb207Cj4+PiBjYXRhbGluLm1hcmluYXNAYXJt
LmNvbTsgd2lsbEBrZXJuZWwub3JnOyBtYXpAa2VybmVsLm9yZzsKPj4+IGphbWVzLm1vcnNlQGFy
bS5jb207IGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbTsgc3V6dWtpLnBvdWxvc2VAYXJtLmNvbTsK
Pj4+IGxvcmVuem8ucGllcmFsaXNpQGFybS5jb207IGd1b2hhbmp1bkBodWF3ZWkuY29tOyBzdWRl
ZXAuaG9sbGFAYXJtLmNvbTsKPj4+IHJhZmFlbEBrZXJuZWwub3JnOyBsZW5iQGtlcm5lbC5vcmc7
IHRvbnkubHVja0BpbnRlbC5jb207IGJwQGFsaWVuOC5kZTsKPj4+IG1hcmsucnV0bGFuZEBhcm0u
Y29tOyBhbnNodW1hbi5raGFuZHVhbEBhcm0uY29tOwo+Pj4gdmluY2Vuem8uZnJhc2Npbm9AYXJt
LmNvbTsgdGFiYmFAZ29vZ2xlLmNvbTsgbWFyY2FuQG1hcmNhbi5zdDsKPj4+IGtlZXNjb29rQGNo
cm9taXVtLm9yZzsganRoaWVycnlAcmVkaGF0LmNvbTsgbWFzYWhpcm95QGtlcm5lbC5vcmc7Cj4+
PiBzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbTsgam9obi5nYXJyeUBodWF3ZWkuY29tOyAKPj4+IGRh
bmllbC5sZXpjYW5vQGxpbmFyby5vcmc7Cj4+PiBnb3JAbGludXguaWJtLmNvbTsgemhhbmdzaGFv
a3VuQGhpc2lsaWNvbi5jb207IHRtcmljaHRAbGludXguaWJtLmNvbTsKPj4+IGRjaGlubmVyQHJl
ZGhhdC5jb207IHRnbHhAbGludXRyb25peC5kZTsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsKPj4+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsga3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdTsKPj4+IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnOyBsaW51eC1l
ZGFjQHZnZXIua2VybmVsLm9yZzsKPj4+IFZpbmVldGguUGlsbGFpQG1pY3Jvc29mdC5jb20KPj4+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8yXSBBQ1BJL0FFU1Q6IEluaXRpYWwgQUVTVCBkcml2ZXIK
Pj4+Cj4+PiBIaSBTaHV1aWNoaXJvdSwKPj4+Cj4+PiBUaGFuayB5b3UgZm9yIHlvdXIgZmVlZGJh
Y2shCj4+Pgo+Pj4gT24gMTIvOS8yMDIxIDM6MTAgQU0sIGlzaGlpLnNodXVpY2hpckBmdWppdHN1
LmNvbSB3cm90ZToKPj4+PiBIaSwgVHlsZXIuCj4+Pj4KPj4+PiBXZSB3b3VsZCBsaWtlIHRvIG1h
a2UgYSBmZXcgY29tbWVudHMuCj4+Pj4KPj4+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0K
Pj4+Pj4gRnJvbTogVHlsZXIgQmFpY2FyIDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5nLmNvbT4K
Pj4+Pj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDI1LCAyMDIxIDI6MDcgQU0KPj4+Pj4gVG86
IHBhdGNoZXNAYW1wZXJlY29tcHV0aW5nLmNvbTsgYWJkdWxoYW1pZEBvcy5hbXBlcmVjb21wdXRp
bmcuY29tOwo+Pj4+PiBkYXJyZW5Ab3MuYW1wZXJlY29tcHV0aW5nLmNvbTsgY2F0YWxpbi5tYXJp
bmFzQGFybS5jb207Cj4+Pj4+IHdpbGxAa2VybmVsLm9yZzsgbWF6QGtlcm5lbC5vcmc7IGphbWVz
Lm1vcnNlQGFybS5jb207Cj4+Pj4+IGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbTsgc3V6dWtpLnBv
dWxvc2VAYXJtLmNvbTsKPj4+Pj4gbG9yZW56by5waWVyYWxpc2lAYXJtLmNvbTsgZ3VvaGFuanVu
QGh1YXdlaS5jb207Cj4+Pj4+IHN1ZGVlcC5ob2xsYUBhcm0uY29tOyByYWZhZWxAa2VybmVsLm9y
ZzsgbGVuYkBrZXJuZWwub3JnOwo+Pj4+PiB0b255Lmx1Y2tAaW50ZWwuY29tOyBicEBhbGllbjgu
ZGU7IG1hcmsucnV0bGFuZEBhcm0uY29tOwo+Pj4+PiBhbnNodW1hbi5raGFuZHVhbEBhcm0uY29t
OyB2aW5jZW56by5mcmFzY2lub0Bhcm0uY29tOwo+Pj4+PiB0YWJiYUBnb29nbGUuY29tOyBtYXJj
YW5AbWFyY2FuLnN0OyBrZWVzY29va0BjaHJvbWl1bS5vcmc7Cj4+Pj4+IGp0aGllcnJ5QHJlZGhh
dC5jb207IG1hc2FoaXJveUBrZXJuZWwub3JnOyBzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbTsKPj4+
Pj4gam9obi5nYXJyeUBodWF3ZWkuY29tOyBkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnOyBnb3JA
bGludXguaWJtLmNvbTsKPj4+Pj4gemhhbmdzaGFva3VuQGhpc2lsaWNvbi5jb207IHRtcmljaHRA
bGludXguaWJtLmNvbTsKPj4+Pj4gZGNoaW5uZXJAcmVkaGF0LmNvbTsgdGdseEBsaW51dHJvbml4
LmRlOwo+Pj4+PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmc7Cj4+Pj4+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7
IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnOwo+Pj4+PiBsaW51eC1lZGFjQHZnZXIua2VybmVs
Lm9yZzsgSXNoaWksIFNodXVpY2hpcm91L+efs+S6lQo+Pj4+PiDlkajkuIDpg44gPGlzaGlpLnNo
dXVpY2hpckBmdWppdHN1LmNvbT47IFZpbmVldGguUGlsbGFpQG1pY3Jvc29mdC5jb20KPj4+Pj4g
Q2M6IFR5bGVyIEJhaWNhciA8YmFpY2FyQG9zLmFtcGVyZWNvbXB1dGluZy5jb20+Cj4+Pj4+IFN1
YmplY3Q6IFtQQVRDSCAxLzJdIEFDUEkvQUVTVDogSW5pdGlhbCBBRVNUIGRyaXZlcgo+Pj4+Pgo+
Pj4+PiBBZGQgc3VwcG9ydCBmb3IgcGFyc2luZyB0aGUgQVJNIEVycm9yIFNvdXJjZSBUYWJsZSBh
bmQgYmFzaWMgaGFuZGxpbmcKPj4+Pj4gb2YgZXJyb3JzIHJlcG9ydGVkIHRocm91Z2ggYm90aCBt
ZW1vcnkgbWFwcGVkIGFuZCBzeXN0ZW0gcmVnaXN0ZXIKPj4+IGludGVyZmFjZXMuCj4+Pj4+Cj4+
Pj4+IEFzc3VtZSBzeXN0ZW0gcmVnaXN0ZXIgaW50ZXJmYWNlcyBhcmUgb25seSByZWdpc3RlcmVk
IHdpdGggcHJpdmF0ZQo+Pj4+PiBwZXJpcGhlcmFsIGludGVycnVwdHMgKFBQSXMpOyBvdGhlcndp
c2UgdGhlcmUgaXMgbm8gZ3VhcmFudGVlIHRoZQo+Pj4+PiBjb3JlIGhhbmRsaW5nIHRoZSBlcnJv
ciBpcyB0aGUgY29yZSB3aGljaCB0b29rIHRoZSBlcnJvciBhbmQgaGFzIHRoZQo+Pj4+PiBzeW5k
cm9tZSBpbmZvIGluIGl0cyBzeXN0ZW0gcmVnaXN0ZXJzLgo+Pj4+Pgo+Pj4+PiBBZGQgbG9nZ2lu
ZyBmb3IgYWxsIGRldGVjdGVkIGVycm9ycyBhbmQgdHJpZ2dlciBhIGtlcm5lbCBwYW5pYyBpZgo+
Pj4+PiB0aGVyZSBpcyBhbnkgdW5jb3JyZWN0ZWQgZXJyb3IgcHJlc2VudC4KPj4+Pj4KPj4+Pj4g
U2lnbmVkLW9mZi1ieTogVHlsZXIgQmFpY2FyIDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5nLmNv
bT4KPj4+Pj4gLS0tCj4+Pj4gWy4uLl0KPj4+Pgo+Pj4+PiArc3RhdGljIGludCBfX2luaXQgYWVz
dF9pbml0X25vZGUoc3RydWN0IGFjcGlfYWVzdF9oZHIgKm5vZGUpIHsKPj4+Pj4gK8KgwqDCoCB1
bmlvbiBhY3BpX2Flc3RfcHJvY2Vzc29yX2RhdGEgKnByb2NfZGF0YTsKPj4+Pj4gK8KgwqDCoCB1
bmlvbiBhZXN0X25vZGVfc3BlYyAqbm9kZV9zcGVjOwo+Pj4+PiArwqDCoMKgIHN0cnVjdCBhZXN0
X25vZGVfZGF0YSAqZGF0YTsKPj4+Pj4gK8KgwqDCoCBpbnQgcmV0Owo+Pj4+PiArCj4+Pj4+ICvC
oMKgwqAgZGF0YSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBhZXN0X25vZGVfZGF0YSksIEdGUF9L
RVJORUwpOwo+Pj4+PiArwqDCoMKgIGlmICghZGF0YSkKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJl
dHVybiAtRU5PTUVNOwo+Pj4+PiArCj4+Pj4+ICvCoMKgwqAgZGF0YS0+bm9kZV90eXBlID0gbm9k
ZS0+dHlwZTsKPj4+Pj4gKwo+Pj4+PiArwqDCoMKgIG5vZGVfc3BlYyA9IEFDUElfQUREX1BUUih1
bmlvbiBhZXN0X25vZGVfc3BlYywgbm9kZSwKPj4+Pj4gbm9kZS0+bm9kZV9zcGVjaWZpY19vZmZz
ZXQpOwo+Pj4+PiArCj4+Pj4+ICvCoMKgwqAgc3dpdGNoIChub2RlLT50eXBlKSB7Cj4+Pj4+ICvC
oMKgwqAgY2FzZSBBQ1BJX0FFU1RfUFJPQ0VTU09SX0VSUk9SX05PREU6Cj4+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBtZW1jcHkoJmRhdGEtPmRhdGEsIG5vZGVfc3BlYywgc2l6ZW9mKHN0cnVjdAo+Pj4+
PiBhY3BpX2Flc3RfcHJvY2Vzc29yKSk7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4+
Pj4gK8KgwqDCoCBjYXNlIEFDUElfQUVTVF9NRU1PUllfRVJST1JfTk9ERToKPj4+Pj4gK8KgwqDC
oMKgwqDCoMKgIG1lbWNweSgmZGF0YS0+ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+
Pj4+IGFjcGlfYWVzdF9tZW1vcnkpKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4+
PiArwqDCoMKgIGNhc2UgQUNQSV9BRVNUX1NNTVVfRVJST1JfTk9ERToKPj4+Pj4gK8KgwqDCoMKg
wqDCoMKgIG1lbWNweSgmZGF0YS0+ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+Pj4+
IGFjcGlfYWVzdF9zbW11KSk7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4+Pj4gK8Kg
wqDCoCBjYXNlIEFDUElfQUVTVF9WRU5ET1JfRVJST1JfTk9ERToKPj4+Pj4gK8KgwqDCoMKgwqDC
oMKgIG1lbWNweSgmZGF0YS0+ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+Pj4+IGFj
cGlfYWVzdF92ZW5kb3IpKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4+PiArwqDC
oMKgIGNhc2UgQUNQSV9BRVNUX0dJQ19FUlJPUl9OT0RFOgo+Pj4+PiArwqDCoMKgwqDCoMKgwqAg
bWVtY3B5KCZkYXRhLT5kYXRhLCBub2RlX3NwZWMsIHNpemVvZihzdHJ1Y3QKPj4+Pj4gYWNwaV9h
ZXN0X2dpYykpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+Pj4+ICvCoMKgwqAgZGVm
YXVsdDoKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGtmcmVlKGRhdGEpOwo+Pj4+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4+ICvCoMKgwqAgfQo+Pj4+PiArCj4+Pj4+ICvCoMKg
wqAgaWYgKG5vZGUtPnR5cGUgPT0gQUNQSV9BRVNUX1BST0NFU1NPUl9FUlJPUl9OT0RFKSB7Cj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoCBwcm9jX2RhdGEgPSBBQ1BJX0FERF9QVFIodW5pb24gYWNwaV9h
ZXN0X3Byb2Nlc3Nvcl9kYXRhLAo+Pj4+PiBub2RlX3NwZWMsCj4+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZihhY3BpX2Flc3RfcHJvY2Vzc29yKSk7
Cj4+Pj4+ICsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHN3aXRjaCAoZGF0YS0+ZGF0YS5wcm9jZXNz
b3IucmVzb3VyY2VfdHlwZSkgewo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgY2FzZSBBQ1BJX0FFU1Rf
Q0FDSEVfUkVTT1VSQ0U6Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1lbWNweSgmZGF0
YS0+cHJvY19kYXRhLCBwcm9jX2RhdGEsCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc2l6ZW9mKHN0cnVjdCBhY3BpX2Flc3RfcHJvY2Vzc29yX2NhY2hlKSk7Cj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAg
Y2FzZSBBQ1BJX0FFU1RfVExCX1JFU09VUkNFOgo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtZW1jcHkoJmRhdGEtPnByb2NfZGF0YSwgcHJvY19kYXRhLAo+Pj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZihzdHJ1Y3QgYWNwaV9hZXN0X3Byb2Nlc3Nv
cl90bGIpKTsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoCBjYXNlIEFDUElfQUVTVF9HRU5FUklDX1JFU09VUkNFOgo+Pj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBtZW1jcHkoJmRhdGEtPnByb2NfZGF0YSwgcHJvY19kYXRhLAo+Pj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZihzdHJ1Y3QgYWNw
aV9hZXN0X3Byb2Nlc3Nvcl9nZW5lcmljKSk7Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGJyZWFrOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgfQo+Pj4+PiArwqDCoMKgIH0KPj4+Pj4gKwo+
Pj4+PiArwqDCoMKgIHJldCA9IGFlc3RfaW5pdF9pbnRlcmZhY2Uobm9kZSwgZGF0YSk7Cj4+Pj4+
ICvCoMKgwqAgaWYgKHJldCkgewo+Pj4+PiArwqDCoMKgwqDCoMKgwqAga2ZyZWUoZGF0YSk7Cj4+
Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+Pj4+PiArwqDCoMKgIH0KPj4+Pj4gKwo+
Pj4+PiArwqDCoMKgIHJldHVybiBhZXN0X2luaXRfaW50ZXJydXB0cyhub2RlLCBkYXRhKTsKPj4+
PiBJZiBhZXN0X2luaXRfaW50ZXJydXB0cygpIGZhaWxlZCwgaXMgaXQgbmVjZXNzYXJ5IHRvIHJl
bGVhc2UgdGhlIGRhdGEKPj4+PiBwb2ludGVyIGFjcXVpcmVkIGJ5IGt6YWxsb2M/Cj4+PiBhZXN0
X2luaXRfaW50ZXJydXB0cygpIHJldHVybnMgYW4gZXJyb3IgaWYgYW55IG9mIHRoZSBpbnRlcnJ1
cHRzIGluIAo+Pj4gdGhlIGludGVycnVwdCBsaXN0Cj4+PiBmYWlscywgYnV0IGl0J3MgcG9zc2li
bGUgdGhhdCBzb21lIGludGVycnVwdHMgaW4gdGhlIGxpc3QgcmVnaXN0ZXJlZCAKPj4+IHN1Y2Nl
c3NmdWxseS4gU28KPj4+IHdlIGF0dGVtcHQgdG8ga2VlcCBjaHVnZ2luZyBhbG9uZyBpbiB0aGF0
IHNjZW5hcmlvIGJlY2F1c2Ugc29tZSAKPj4+IGludGVycnVwdHMgbWF5Cj4+PiBiZSBlbmFibGVk
IGFuZCByZWdpc3RlcmVkIHdpdGggdGhlIGludGVyZmFjZSBzdWNjZXNzZnVsbHkuIElmIGFueSAK
Pj4+IGludGVycnVwdAo+Pj4gcmVnaXN0cmF0aW9uIGZhaWxzLCB0aGVyZSB3aWxsIGJlIGEgcHJp
bnQgbm90aWZ5aW5nIHRoYXQgdGhlcmUgd2FzIGEgCj4+PiBmYWlsdXJlIHdoZW4KPj4+IGluaXRp
YWxpemluZyB0aGF0IG5vZGUuCj4+Pj4+ICt9Cj4+Pj4+ICsKPj4+Pj4gK3N0YXRpYyB2b2lkIGFl
c3RfY291bnRfcHBpKHN0cnVjdCBhY3BpX2Flc3RfaGRyICpub2RlKQo+Pj4+PiArewo+Pj4+PiAr
wqDCoMKgIHN0cnVjdCBhY3BpX2Flc3Rfbm9kZV9pbnRlcnJ1cHQgKmludGVycnVwdDsKPj4+Pj4g
K8KgwqDCoCBpbnQgaTsKPj4+Pj4gKwo+Pj4+PiArwqDCoMKgIGludGVycnVwdCA9IEFDUElfQURE
X1BUUihzdHJ1Y3QgYWNwaV9hZXN0X25vZGVfaW50ZXJydXB0LCBub2RlLAo+Pj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbm9kZS0+bm9kZV9pbnRlcnJ1cHRfb2Zmc2V0KTsK
Pj4+Pj4gKwo+Pj4+PiArwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBub2RlLT5ub2RlX2ludGVycnVw
dF9jb3VudDsgaSsrLCBpbnRlcnJ1cHQrKykgewo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGlu
dGVycnVwdC0+Z3NpdiA+PSAxNiAmJiBpbnRlcnJ1cHQtPmdzaXYgPCAzMikKPj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgbnVtX3BwaSsrOwo+Pj4+PiArwqDCoMKgIH0KPj4+Pj4gK30KPj4+
Pj4gKwo+Pj4+PiArc3RhdGljIGludCBhZXN0X3N0YXJ0aW5nX2NwdSh1bnNpZ25lZCBpbnQgY3B1
KQo+Pj4+PiArewo+Pj4+PiArwqDCoMKgIGludCBpOwo+Pj4+PiArCj4+Pj4+ICvCoMKgwqAgZm9y
IChpID0gMDsgaSA8IG51bV9wcGk7IGkrKykKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGVuYWJsZV9w
ZXJjcHVfaXJxKHBwaV9pcnFzW2ldLCBJUlFfVFlQRV9OT05FKTsKPj4+Pj4gKwo+Pj4+PiArwqDC
oMKgIHJldHVybiAwOwo+Pj4+PiArfQo+Pj4+PiArCj4+Pj4+ICtzdGF0aWMgaW50IGFlc3RfZHlp
bmdfY3B1KHVuc2lnbmVkIGludCBjcHUpCj4+Pj4+ICt7Cj4+Pj4gV291bGRuJ3QgaXQgYmUgYmV0
dGVyIHRvIGV4ZWN1dGUgZGlzYWJsZV9wZXJjcHVfaXJxKCksIHdoaWNoIGlzIHBhaXJlZAo+Pj4+
IHdpdGggZW5hYmxlX3BlcmNwdV9pcnEoKSwgaW4gYWVzdF9keWluZ19jcHUoKT8KPj4+Cj4+PiBH
b29kIHBvaW50LiBJIHdpbGwgYWRkIHRoYXQgaW4gdGhlIG5leHQgdmVyc2lvbi4KPj4+Cj4+PiBU
aGFua3MsCj4+Pgo+Pj4gVHlsZXIKPj4KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwo+IGt2bWFybSBtYWlsaW5nIGxpc3QKPiBrdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cj4gaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
