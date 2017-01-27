From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Increase number of memslots to 512
Date: Fri, 27 Jan 2017 19:08:25 +0530
Message-ID: <CACJhumeA5FBNQUph6shCPE65=UAxiwfo97LK=3tReKbdyniduw@mail.gmail.com>
References: <1484153537-20984-1-git-send-email-linucherian@gmail.com>
 <61fa02f8-b244-6bae-eaa1-cb745ea543e1@arm.com>
 <CAGOz-0aD-hV7sDAX70pSGdCj1J4s4xc4qQBwbaKzVZArfRK2AQ@mail.gmail.com>
 <6fc30f74-d1ab-028f-7e5f-a5d1fe69c17a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <6fc30f74-d1ab-028f-7e5f-a5d1fe69c17a@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: sunil.goutham@cavium.com, rkrcmar@redhat.com, bprakash@caviumnetworks.com, Linu Cherian <linucherian@gmail.com>, linux-arm-kernel@lists.infradead.org, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

> Can you shed some light on your test process?
Hi Linu / Marc Zyngier,

I tested this patch on top of latest VFIO MSI supported version 9
patches on ThunderX with internal 10G VNIC and Intel IXGBE NIC.
Please feel free to add my:
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>

Thanks,
 prakash B
