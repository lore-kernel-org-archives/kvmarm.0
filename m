Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EFBC33CA2
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 12:01:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2139E2072A
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 12:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="cG0QOwda"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2139E2072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC9E4B181;
	Fri, 10 Jan 2020 07:01:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 775D00O4wlI0; Fri, 10 Jan 2020 07:01:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0764B176;
	Fri, 10 Jan 2020 07:01:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCF5B4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 14:47:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id umjLYyO27Bmy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 14:47:47 -0500 (EST)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED91A4B1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 14:47:46 -0500 (EST)
Received: by mail-pf1-f194.google.com with SMTP id x185so3849250pfc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jan 2020 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=tOr15WETxbkLw/hVhIIJI77xVs+gy+a9H8+1jFpIRfc=;
 b=cG0QOwda3n2lMKGGwl2gvG+FY0g5k14CGaWhbv4nmRcoT2JX4qtut3O08AYJiZSsJ1
 cr8cRqsI97d5/bOkzP8tKl3Tt9qtR5JvXtPKrWUCiPl4DV38hUy0eNUJDkm8kHbJEuBE
 yaFZx1vNucRxrssnQpATjd86jpNCMGp+2Uyc8U06zuHuUL2AoQcrnZJ+y884oRxt8t+n
 VRC8uxlGUAtadaiER22t+8Zb5vtrFxei+x4QHt8BHfVM01jX4dRRdZl9Mv3Dje2YTVYW
 tV4Ihp6XBYA3izk3Ms3j7QY4sBnbwek7lIwiWDhHQ5xPFFbll2klVlmKSmR8wUaYCyZ9
 y5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=tOr15WETxbkLw/hVhIIJI77xVs+gy+a9H8+1jFpIRfc=;
 b=IoJv7VAwRHEKPnMQ+VLcGN8RzcNTPj6PpPjYl/P5Pkf/RJzfngWrrq8lPcZlHe1j7Y
 SuRe8BalfyjVffZ4UmiL45SreG2pfW0Im43N7ASOFj2PigSkgJ2+eospApFW0xyFDQlm
 GFfizf4be1b7/vIHZCJGgCT4eWs5gUhy9y3BVXoRDUdsl9hOrYvzMTreS3lP4KBEczOY
 31WhjsYtKh7/l/u0W10NQcXb4DtE3cfNnR+dIbv+Si6oBt6OW4JRdnSQx0MQ3+QT4omX
 vt0tJDy8pwoiidrvAukRPOH0wzg6phGH3LYpdYjZfJ/EtN/whrf3oqqTOvKEtMU6ACtj
 PdoA==
X-Gm-Message-State: APjAAAWJDC6M+yvzGE5qY6YXo+0c62vjnVuVFVSU6jIB2F//fBoB6NOu
 AMvQaruzkJppbfhDn42o05bS1g==
X-Google-Smtp-Source: APXvYqzh23zJ0M/6YUkb1gak5IeC/b1rxGMe/2+na8ui5AM37mG7vNvlQ/Y50JVkaXV8dlCW2yJyFQ==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr235672pfh.124.1578599265739; 
 Thu, 09 Jan 2020 11:47:45 -0800 (PST)
Received: from gnomeregan01.cam.corp.google.com
 ([2620:15c:6:14:50b7:ffca:29c4:6488])
 by smtp.googlemail.com with ESMTPSA id z130sm8572761pgz.6.2020.01.09.11.47.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Jan 2020 11:47:44 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
From: Barret Rhoden <brho@google.com>
Message-ID: <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
Date: Thu, 9 Jan 2020 14:47:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 10 Jan 2020 07:01:03 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Jason Zeng <jason.zeng@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi -

On 1/8/20 3:24 PM, Sean Christopherson wrote:
> This series is a mix of bug fixes, cleanup and new support in KVM's
> handling of huge pages.  The series initially stemmed from a syzkaller
> bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
> check for THP when populating secondary MMU".
> 
> While investigating options for fixing the syzkaller bug, I realized KVM
> could reuse the approach from Barret's series to enable huge pages for DAX
> mappings in KVM[2] for all types of huge mappings, i.e. walk the host page
> tables instead of querying metadata (patches 05 - 09).

Thanks, Sean.  I tested this patch series out, and it works for me. 
(Huge KVM mappings of a DAX file, etc.).

Thanks,

Barret



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
