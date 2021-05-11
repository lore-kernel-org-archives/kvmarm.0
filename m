Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43A2C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 16:43:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A1946187E
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 16:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A1946187E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80ECD4B3FC;
	Tue, 11 May 2021 12:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AszDKlZdrcpX; Tue, 11 May 2021 12:43:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 423EE4B43F;
	Tue, 11 May 2021 12:43:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 846124B3FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 12:43:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPutFHi9Amhv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 12:43:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 439A94B3AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 12:43:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620751414;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CrGA+D+8f54f1+nxV7IrzOSl9kjMbEITXdJTmR0d2xM=;
 b=PNkQ2RQdRaUFmnTQx2kzanNKWQ/D5Ade0lhEGmUljq594HAmEbkZ13lbLbc+MBdgPZr5Z3
 IhYNYhn3kNK4Mn/XZJbkWziqnH+rTtAMBikzulhIHsKRKWT2dppvdREvlebOhH7+gIunB3
 sGw5fU5k57G0ik4goW/GswnwUtOb4Zs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-iQZ1aNkaOzChC6X4Eo7c9w-1; Tue, 11 May 2021 12:43:33 -0400
X-MC-Unique: iQZ1aNkaOzChC6X4Eo7c9w-1
Received: by mail-ed1-f69.google.com with SMTP id
 g19-20020a0564021813b029038811907178so11235001edy.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 09:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=CrGA+D+8f54f1+nxV7IrzOSl9kjMbEITXdJTmR0d2xM=;
 b=W5Mx0EuYMXWbO8GtrjJs23kieHsgnYQqgvjZpGquQhlgBQypgPSJE8mXFB5Y+2mxK3
 6VZ8cgTshE8W5DH8xM0tqwnGmctr2NcL6Ll7qSrDFPmGwWIVd8GY8vIyMpp7m2bEfmTV
 RJmZ0oNgAcZfdZi//FlY4naMNzhCdwMk2NtZ59y2T3ypEGXXF87OEyEqPW0GKVKVb/KR
 cjpSUMWHnAARxvyKYjlkBhZo5mwN8L9MHD5ShgeUuHfvJlQC0FUBWICFxgnNA+Be+V09
 CO/1EW/FgLO+/t0KQwJoM2uGaLnrSMGQc7XnmFBUJKtnV2tb1W/TF1NDYCXxRLJTzmyC
 SeZQ==
X-Gm-Message-State: AOAM5304DD2A754oz3KMsoHbYee+1SRDmOYcgAjv4HyafCD31GY5lygi
 5NoNX+0GnwE6GCgeLWSEUjE/MgBs9xqq+XY/3LdzgcFs8tfe/d1q7fg10nbS7NpZnkn2qpOD/5g
 kouV79qqn+xRAjhAogBG/PRsDP8BEP18wD/GcRKbtLTLMweUT/igAjbC+4xin4wNbaJS0RZUs/U
 9u
X-Received: by 2002:a17:907:3f08:: with SMTP id
 hq8mr32471627ejc.240.1620751411657; 
 Tue, 11 May 2021 09:43:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7LEBazZuNjjeyOKzf6kpQzUc1ilpWqgIgbuK6Aon1KOjeokHhMN6rG5rWq4MOW+24fVtixw==
X-Received: by 2002:a17:907:3f08:: with SMTP id
 hq8mr32471595ejc.240.1620751411318; 
 Tue, 11 May 2021 09:43:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id d24sm15028690edp.31.2021.05.11.09.43.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 11 May 2021 09:43:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>,
 kvm-devel <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <604b1638-452f-e8e3-b674-014d634e2767@redhat.com>
Date: Tue, 11 May 2021 18:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

T24gMTEvMDUvMjEgMTc6NDMsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4gSGVsbG8sCj4gCj4g
Q29tbWl0IDBiMmQzZGFmYzBkMyAoImxpYmNmbGF0OiBwcm92aWRlIGxvbmcgZGl2aXNpb24gcm91
dGluZXMiKSwgd2hpY2ggYWRkZWQgdGhlCj4gbGliL2xkaXYzMi5jIGZpbGUsIGJyZWFrcyBjb21w
aWxhdGlvbiBmb3IgdGhlIGFybSBhcmNoaXRlY3R1cmU7IGFybTY0IHNlZW1zIHRvIGJlCj4gd29y
a2luZyBqdXN0IGZpbmUuCgpUaGUgRmVkb3JhIG9uZSBpcyBmaXhlZCBpbiB0aGUgY29tbWl0IGlt
bWVkaWF0ZWx5IGFmdGVyLCB3aGljaCByZXBsYWNlcyAKaW50dHlwZXMuaCB3aXRoIHN0ZGludC5o
LgoKRm9yIEFyY2ggTGludXggSSdtIG5vdCBzdXJlIHdoYXQgdGhlIGNvbXBpbGVyIGlzIGNvbXBs
YWluaW5nIGFib3V0IAooZXNwZWNpYWxseSBzaW5jZSB0aGVyZSBhcmUgbm8gb3B0aW9ucyBzdWNo
IGFzIC1mbm8tbnVsbC1wb2ludGVyLWNoZWNrcykgCmJ1dCBwZXJoYXBzIHdlIGNhbiBqdXN0IGlu
aXRpYWxpemUgcmVtIHRvIDA/ICBBbnkgY2hhbmNlIHlvdSBjYW4gY2hlY2sgCmlmIHRoYXQgYWZm
ZWN0cyB0aGUgYXNzZW1ibHkgb3V0cHV0PyAgKEl0IHNob3VsZG4ndCkuCgpQYW9sbwoKPiBPbiBB
cmNoIExpbnV4Ogo+IAo+ICQgLi9jb25maWd1cmUgLS1hcmNoPWFybSAtLWNyb3NzLXByZWZpeD1h
cm0tbm9uZS1lYWJpLQo+ICQgbWFrZSBjbGVhbiAmJiBtYWtlCj4gcm0gLWYgbGliL2FybS9hc20t
b2Zmc2V0cy5oIGxpYi9hcm0vYXNtLW9mZnNldHMucyBcCj4gIMKgwqDCoMKgwqAgbGliL2dlbmVy
YXRlZC9hc20tb2Zmc2V0cy5oCj4gcm0gLWYgYXJtLyoue28sZmxhdCxlbGZ9IGxpYi9hcm0vbGli
ZWFiaS5hIGxpYi9hcm0vZWFiaV9jb21wYXQubyBcCj4gIMKgwqDCoMKgwqAgYXJtLy4qLmQgbGli
L2FybS8uKi5kCj4gIMKgIENMRUFOIChsaWJmZHQpCj4gcm0gLWYgbGliL2xpYmZkdC8qLm8gbGli
L2xpYmZkdC8uKi5kCj4gcm0gLWYgbGliL2xpYmZkdC9saWJmZHQuc28uMQo+IHJtIC1mIGxpYi9s
aWJmZHQvbGliZmR0LmEKPiBybSAtZiBsaWIvLiouZCBsaWIvbGliY2ZsYXQuYSBsaWIvYXJndi5v
IGxpYi9wcmludGYubyBsaWIvc3RyaW5nLm8gbGliL2Fib3J0Lm8KPiBsaWIvcmVwb3J0Lm8gbGli
L3N0YWNrLm8gbGliL2FybS9zcGlubG9jay5vIGxpYi9hcm0vcHJvY2Vzc29yLm8gbGliL2FybS9z
dGFjay5vCj4gbGliL2xkaXYzMi5vIGxpYi91dGlsLm8gbGliL2dldGNoYXIubyBsaWIvYWxsb2Nf
cGh5cy5vIGxpYi9hbGxvY19wYWdlLm8KPiBsaWIvdm1hbGxvYy5vIGxpYi9hbGxvYy5vIGxpYi9k
ZXZpY2V0cmVlLm8gbGliL3BjaS5vIGxpYi9wY2ktaG9zdC1nZW5lcmljLm8KPiBsaWIvcGNpLXRl
c3RkZXYubyBsaWIvdmlydGlvLm8gbGliL3ZpcnRpby1tbWlvLm8gbGliL2Noci10ZXN0ZGV2Lm8g
bGliL2FybS9pby5vCj4gbGliL2FybS9zZXR1cC5vIGxpYi9hcm0vbW11Lm8gbGliL2FybS9iaXRv
cHMubyBsaWIvYXJtL3BzY2kubyBsaWIvYXJtL3NtcC5vCj4gbGliL2FybS9kZWxheS5vIGxpYi9h
cm0vZ2ljLm8gbGliL2FybS9naWMtdjIubyBsaWIvYXJtL2dpYy12My5vCj4gWy4uXQo+IGFybS1u
b25lLWVhYmktZ2NjIC1tYXJtIC1tZnB1PXZmcCAtbWNwdT1jb3J0ZXgtYTE1IC1tbm8tdW5hbGln
bmVkLWFjY2Vzcwo+IC1zdGQ9Z251OTkgLWZmcmVlc3RhbmRpbmcgLU8yIC1JIC9ob21lL2FsZXgv
ZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0cy9saWIgLUkKPiAvaG9tZS9hbGV4L2RhdGEvcmVwb3Mv
a3ZtLXVuaXQtdGVzdHMvbGliL2xpYmZkdCAtSSBsaWIgLWcgLU1NRCAtTUYgbGliLy5sZGl2MzIu
ZAo+IC1mbm8tc3RyaWN0LWFsaWFzaW5nIC1mbm8tY29tbW9uIC1XYWxsIC1Xd3JpdGUtc3RyaW5n
cyAtV2VtcHR5LWJvZHkKPiAtV3VuaW5pdGlhbGl6ZWQgLVdpZ25vcmVkLXF1YWxpZmllcnMgLVdl
cnJvcsKgIC1mbm8tb21pdC1mcmFtZS1wb2ludGVyCj4gLWZuby1zdGFjay1wcm90ZWN0b3LCoMKg
wqAgLVduby1mcmFtZS1hZGRyZXNzIC1EX19VMzJfTE9OR19GTVRfX8KgIC1mbm8tcGljwqAgLW5v
LXBpZQo+IC1XY2xvYmJlcmVkwqAgLVd1bnVzZWQtYnV0LXNldC1wYXJhbWV0ZXLCoCAtV21pc3Np
bmctcGFyYW1ldGVyLXR5cGUKPiAtV29sZC1zdHlsZS1kZWNsYXJhdGlvbiAtV292ZXJyaWRlLWlu
aXQgLVdtaXNzaW5nLXByb3RvdHlwZXMgLVdzdHJpY3QtcHJvdG90eXBlcwo+IC1jIC1vIGxpYi9s
ZGl2MzIubyBsaWIvbGRpdjMyLmMKPiBsaWIvbGRpdjMyLmM6IEluIGZ1bmN0aW9uICdfX21vZGRp
Myc6Cj4gbGliL2xkaXYzMi5jOjczOjExOiBlcnJvcjogJ3JlbScgbWF5IGJlIHVzZWQgdW5pbml0
aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uCj4gWy1XZXJyb3I9bWF5YmUtdW5pbml0aWFsaXplZF0K
PiAgwqDCoCA3MyB8wqAgdWludDY0X3QgcmVtOwo+ICDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDC
oMKgwqDCoCBefn4KPiBsaWIvbGRpdjMyLmM6IEluIGZ1bmN0aW9uICdfX3Vtb2RkaTMnOgo+IGxp
Yi9sZGl2MzIuYzo3NTo5OiBlcnJvcjogJ3JlbScgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBp
biB0aGlzIGZ1bmN0aW9uCj4gWy1XZXJyb3I9bWF5YmUtdW5pbml0aWFsaXplZF0KPiAgwqDCoCA3
NSB8wqAgcmV0dXJuIHJlbTsKPiAgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoCBefn4KPiBj
YzE6IGFsbCB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycwo+IG1ha2U6ICoqKiBbPGJ1
aWx0aW4+OiBsaWIvbGRpdjMyLm9dIEVycm9yIDEKPiAkIGFybS1ub25lLWVhYmktZ2NjIC0tdmVy
c2lvbgo+IGFybS1ub25lLWVhYmktZ2NjIChBcmNoIFJlcG9zaXRvcnkpIDEwLjMuMAo+IENvcHly
aWdodCAoQykgMjAyMCBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4KPiBUaGlzIGlzIGZy
ZWUgc29mdHdhcmU7IHNlZSB0aGUgc291cmNlIGZvciBjb3B5aW5nIGNvbmRpdGlvbnMuwqAgVGhl
cmUgaXMgTk8KPiB3YXJyYW50eTsgbm90IGV2ZW4gZm9yIE1FUkNIQU5UQUJJTElUWSBvciBGSVRO
RVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4KPiAKPiBPbiBGZWRvcmEgMzM6Cj4gCj4gJCAu
L2NvbmZpZ3VyZSAtLWFyY2g9YXJtIC0tY3Jvc3MtcHJlZml4PWFybS1saW51eC1nbnUtCj4gJCBt
YWtlIGNsZWFuICYmIG1ha2UKPiBybSAtZiBsaWIvYXJtL2FzbS1vZmZzZXRzLmggbGliL2FybS9h
c20tb2Zmc2V0cy5zIFwKPiAgwqDCoMKgwqDCoCBsaWIvZ2VuZXJhdGVkL2FzbS1vZmZzZXRzLmgK
PiBybSAtZiBhcm0vKi57byxmbGF0LGVsZn0gbGliL2FybS9saWJlYWJpLmEgbGliL2FybS9lYWJp
X2NvbXBhdC5vIFwKPiAgwqDCoMKgwqDCoCBhcm0vLiouZCBsaWIvYXJtLy4qLmQKPiAgwqAgQ0xF
QU4gKGxpYmZkdCkKPiBybSAtZiBsaWIvbGliZmR0LyoubyBsaWIvbGliZmR0Ly4qLmQKPiBybSAt
ZiBsaWIvbGliZmR0L2xpYmZkdC5zby4xCj4gcm0gLWYgbGliL2xpYmZkdC9saWJmZHQuYQo+IHJt
IC1mIGxpYi8uKi5kIGxpYi9saWJjZmxhdC5hIGxpYi9hcmd2Lm8gbGliL3ByaW50Zi5vIGxpYi9z
dHJpbmcubyBsaWIvYWJvcnQubwo+IGxpYi9yZXBvcnQubyBsaWIvc3RhY2subyBsaWIvYXJtL3Nw
aW5sb2NrLm8gbGliL2FybS9wcm9jZXNzb3IubyBsaWIvYXJtL3N0YWNrLm8KPiBsaWIvbGRpdjMy
Lm8gbGliL3V0aWwubyBsaWIvZ2V0Y2hhci5vIGxpYi9hbGxvY19waHlzLm8gbGliL2FsbG9jX3Bh
Z2Uubwo+IGxpYi92bWFsbG9jLm8gbGliL2FsbG9jLm8gbGliL2RldmljZXRyZWUubyBsaWIvcGNp
Lm8gbGliL3BjaS1ob3N0LWdlbmVyaWMubwo+IGxpYi9wY2ktdGVzdGRldi5vIGxpYi92aXJ0aW8u
byBsaWIvdmlydGlvLW1taW8ubyBsaWIvY2hyLXRlc3RkZXYubyBsaWIvYXJtL2lvLm8KPiBsaWIv
YXJtL3NldHVwLm8gbGliL2FybS9tbXUubyBsaWIvYXJtL2JpdG9wcy5vIGxpYi9hcm0vcHNjaS5v
IGxpYi9hcm0vc21wLm8KPiBsaWIvYXJtL2RlbGF5Lm8gbGliL2FybS9naWMubyBsaWIvYXJtL2dp
Yy12Mi5vIGxpYi9hcm0vZ2ljLXYzLm8KPiBbLi5dCj4gYXJtLWxpbnV4LWdudS1nY2MgLW1hcm0g
LW1mcHU9dmZwIC1tY3B1PWNvcnRleC1hMTUgLW1uby11bmFsaWduZWQtYWNjZXNzCj4gLXN0ZD1n
bnU5OSAtZmZyZWVzdGFuZGluZyAtTzIgLUkgL2hvbWUvYWxleC9kYXRhL3JlcG9zL2t2bS11bml0
LXRlc3RzL2xpYiAtSQo+IC9ob21lL2FsZXgvZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0cy9saWIv
bGliZmR0IC1JIGxpYiAtZyAtTU1EIC1NRiBsaWIvLmxkaXYzMi5kCj4gLWZuby1zdHJpY3QtYWxp
YXNpbmcgLWZuby1jb21tb24gLVdhbGwgLVd3cml0ZS1zdHJpbmdzIC1XZW1wdHktYm9keQo+IC1X
dW5pbml0aWFsaXplZCAtV2lnbm9yZWQtcXVhbGlmaWVycyAtV2Vycm9ywqAgLWZuby1vbWl0LWZy
YW1lLXBvaW50ZXIKPiAtZm5vLXN0YWNrLXByb3RlY3RvcsKgwqDCoCAtV25vLWZyYW1lLWFkZHJl
c3PCoMKgIC1mbm8tcGljwqAgLW5vLXBpZcKgIC1XY2xvYmJlcmVkCj4gLVd1bnVzZWQtYnV0LXNl
dC1wYXJhbWV0ZXLCoCAtV21pc3NpbmctcGFyYW1ldGVyLXR5cGXCoCAtV29sZC1zdHlsZS1kZWNs
YXJhdGlvbgo+IC1Xb3ZlcnJpZGUtaW5pdCAtV21pc3NpbmctcHJvdG90eXBlcyAtV3N0cmljdC1w
cm90b3R5cGVzwqDCoCAtYyAtbyBsaWIvbGRpdjMyLm8KPiBsaWIvbGRpdjMyLmMKPiBsaWIvbGRp
djMyLmM6MToxMDogZmF0YWwgZXJyb3I6IGludHR5cGVzLmg6IE5vIHN1Y2ggZmlsZSBvciBkaXJl
Y3RvcnkKPiAgwqDCoMKgIDEgfCAjaW5jbHVkZSA8aW50dHlwZXMuaD4KPiAgwqDCoMKgwqDCoCB8
wqDCoMKgwqDCoMKgwqDCoMKgIF5+fn5+fn5+fn5+fgo+IGNvbXBpbGF0aW9uIHRlcm1pbmF0ZWQu
Cj4gbWFrZTogKioqIFs8YnVpbHRpbj46IGxpYi9sZGl2MzIub10gRXJyb3IgMQo+ICQgYXJtLWxp
bnV4LWdudS1nY2MgLS12ZXJzaW9uCj4gYXJtLWxpbnV4LWdudS1nY2MgKEdDQykgMTAuMi4xIDIw
MjAwODI2IChSZWQgSGF0IENyb3NzIDEwLjIuMS0zKQo+IENvcHlyaWdodCAoQykgMjAyMCBGcmVl
IFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4KPiBUaGlzIGlzIGZyZWUgc29mdHdhcmU7IHNlZSB0
aGUgc291cmNlIGZvciBjb3B5aW5nIGNvbmRpdGlvbnMuwqAgVGhlcmUgaXMgTk8KPiB3YXJyYW50
eTsgbm90IGV2ZW4gZm9yIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VM
QVIgUFVSUE9TRS4KPiAKPiBSZXZlcnRpbmcgdGhlIGNvbW1pdCBtYWtlcyBhcm0gYnVpbGQgYWdh
aW4uIEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdG9vbGNoYWlucywgYW5kCj4gdW5mb3J0dW5hdGVs
eSBJIGNhbid0IHByb3Bvc2UgYSBmaXguCj4gCj4gVGhhbmtzLAo+IAo+IEFsZXgKPiAKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
