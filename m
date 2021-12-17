Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D259C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 14:51:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4A24B29E;
	Fri, 17 Dec 2021 09:51:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SrFwstAHxY79; Fri, 17 Dec 2021 09:51:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED854B2C1;
	Fri, 17 Dec 2021 09:51:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B574B29E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 09:51:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qf6nugMUfXth for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 09:51:21 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C6B74B271
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 09:51:21 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id r17so4189959wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 06:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=mnebuQGqRVJGN2DsZ9eHW1+KpUOSevBvrqS9hjun5HA=;
 b=ZjTNEfc6zK60plX/MF6o4daNldO/KbO+PvVYiMB+SaIqCvXZ7TyjN1ZuSFyxaBe0ZG
 rGdblOWXBUAlA4vJY9vIHZilZZdkP6G4OQvKA9HBbK+/POhbux6DZV+Xn9aZh+7D25gw
 YsI/wAiMr6cVQl5HhqR6J96714rjxCTwE0QG5DjZLonH69P1U/gTHclxEM49QmKKeu0U
 iqIv5Da3muuv/zmHQ0QMecdPqFGvv/ZIN4VGGVgh4WJstnMFjj3ogLdiDmqH16wu06NS
 1QGuE4q9HejJCgL+FS/XIgsS0/2noHo3BdkBa/ZZu60rQrVxcpJul8pShfrUNGvuJ1S5
 G8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=mnebuQGqRVJGN2DsZ9eHW1+KpUOSevBvrqS9hjun5HA=;
 b=5kWUys2Vn8joGS8W5NB96wWPcJIE66Ar0Gowf7VBwHXN8oQd7qFox9f8240fyzzaxf
 L2SnWIG9kn3tO5/32fQdIBhq0zO5BwODUSH3IUoaUmT3LttoCoHMMGwdCkaEovo8sZ0w
 7ceWl4L4g89BQYOiPrjLxhweKQC3tZwE11Tqap6J1V6hXVfX8pOXowwlKoRzM26Qwg70
 /8Cui4OB1oQfz1+gWWinB9hQhdQ1K4koWT81ANmja8LmvRRXxvVrNfjaV64TKVPcs7FZ
 1hQXhdIVEeuIS3LhjXuUYZodMZVawJvrJ8qNNTAhR0+XSlA8tzwVbcgABZnKuBBMa88+
 ViUQ==
X-Gm-Message-State: AOAM530MKQFtBS8rtC8ESqxlrBInPC847Gc23+MmByANFHdDHYGkvT9K
 pW6K69nMSN6LCi0tBrEtgWo=
X-Google-Smtp-Source: ABdhPJxEcEhIcUYsKzOAN6IqL39vwVjInx/LM/aFur/79bTs0fYRfHfINZo6PTnpTWAnMXXZlNDMJg==
X-Received: by 2002:adf:ca0f:: with SMTP id o15mr2828708wrh.457.1639752680231; 
 Fri, 17 Dec 2021 06:51:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe?
 ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
 by smtp.googlemail.com with ESMTPSA id a10sm12136566wmq.27.2021.12.17.06.51.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Dec 2021 06:51:19 -0800 (PST)
Message-ID: <ada9b2aa-f1e7-d566-0384-002890441a30@redhat.com>
Date: Fri, 17 Dec 2021 15:51:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Content-Language: en-US
To: Mark Rutland <mark.rutland@arm.com>,
 Nicolas Saenz Julienne <nsaenzju@redhat.com>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, Anup Patel <Anup.Patel@wdc.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On 12/17/21 14:21, Mark Rutland wrote:
> I'm not immediately sure what we*should*  do here. What does x86 do for an IRQ
> taken from a guest mode? I couldn't spot any handling of that case, but I'm not
> familiar enough with the x86 exception model to know if I'm looking in the
> right place.

ARM is missing something like commit 160457140187 ("KVM: x86: Defer 
vtime accounting 'til after IRQ handling", 2021-05-05).

With that change, it would be possible to move guest_exit() in the 
irq-disabled region without breaking time accounting.

RISC-V has the same issue and it would be fixed in the same way, so 
let's Cc Anup too.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
